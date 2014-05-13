class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  REQUEST_TYPES = {
    'a' => 'affidavit',
    'c' => 'common',
    'p' => 'preferential'
  }.freeze.with_indifferent_access

  attr_accessor :related_enrolle, :related_product, :related_varieties,
    :related_destiny, :related_depositary_enrolle, :obs0, :obs1, :obs2

  validates :generated_at, :quantity, presence: true
  validates :harvest, numericality: {
    allow_blank: true, allow_nil: true,
    greater_than_or_equal_to: 1500,
    less_than_or_equal_to: ->(d) { Date.today.year }
  }

  ['enrolle', 'product', 'destiny', 'depositary_enrolle'].each do |t|
    validates :"related_#{t}", presence: true, if: :"#{t}_blank?"
  end

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :depositary_enrolle, class_name: InvEnrolle,
    foreign_key: 'depositary_enrolle_code'

  before_validation :format_observations, :assign_only_the_codes

  def to_s
    self.enrolle
  end

  def assign_only_the_codes
    if !self.enrolle_code && (enrol_code = self.related_enrolle.match(/\[(\w\d+)\]/))
      self.enrolle_code = enrol_code[1]
    end

    if !self.product_code && (prod_code = self.related_product.match(/\[(\d+)\]/))
      self.product_code = prod_code[1]
    end

    self.related_varieties.split(',').each do |code|
      self.variety_codes += [code.to_i] unless self.variety_codes.include?(code.to_i)
    end if self.related_varieties.present?

    if !self.depositary_enrolle_code &&
      (dep_code = self.related_depositary_enrolle.match(/\[(\w\d+)\]/))
      self.depositary_enrolle_code = dep_code[1]
    end

    self.related_destiny.split(',').each do |d|
      self.destiny_codes += [d.to_i] unless self.destiny_codes.include?(d.to_i)
    end if self.related_destiny.present?
  end

  def generate_cardboard
    Printer.generate_cardboard(self)
  end

  def generate_form
    Printer.generate_form(self)
  end

  def file_path(type)
    Rails.root.join('tmp', 'to_print', "#{self.try(:id)}-#{type}.pdf").to_s
  end

  def deleted?
    self.deleted_at.present?
  end

  ['enrolle', 'product', 'depositary_enrolle'].each do |t|
    define_method("#{t}_blank?") do
      self.send("#{t}_code").blank? && self.send("related_#{t}").blank?
    end
  end

  def destiny_blank?
    self.related_destiny.blank? && self.destiny_codes.nil?
  end

  def destroy
    self.deleted_at = Time.zone.now
    self.save!
  end

  def destinies
    (self.destiny_codes.any? { |d| d == 99999 } ? [$europa_obj] : []) +
      InvDestiny.where(codpais: self.destiny_codes)
  end

  def destinies=(codes)
    self.destiny_codes = codes.sort
  end

  REQUEST_TYPES.each do |k, v|
    define_method("#{v}?") { self.request_type == k }
  end

  def variety_names
    self.variety_codes.map { |v| InvVariety.find(v).name }
  end

  def varieties
    InvVariety.where(codvar: self.variety_codes)
  end

  def variety_short_names
    variety_names.size > 2 ? variety_names.map {|v| v.truncate(15) } : variety_names
  end

  def format_observations
    self.set_observations
  end

  def set_observations
    if self.obs0 || self.obs1 || self.obs2
      self.observations = (0..self.obs0.size).map do |i|
        row = [obs0[i], obs1[i], obs2[i]].join("\t")
        row.present? ? row : nil
      end.compact.join("\n")
    end
  end
end
