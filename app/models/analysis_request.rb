class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  REQUEST_TYPES = {
    'a' => 'affidavit',
    'c' => 'common',
    'p' => 'preferential'
  }.freeze.with_indifferent_access

  attr_accessor :related_enrolle, :related_product, :related_varieties,
    :related_destiny, :related_depositary_enrolle

  validates :generated_at, :quantity, :harvest, presence: true
  validates :harvest, numericality: {
    allow_blank: true, allow_nil: true,
    greater_than_or_equal_to: 1500,
    less_than_or_equal_to: ->(d) { Date.today.year }
  }

  ['enrolle', 'product', 'destiny', 'varieties', 'depositary_enrolle'].each do |t|
    validates :"related_#{t}", presence: true, if: :"#{t}_blank?"
  end

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :depositary_enrolle, class_name: InvEnrolle,
    foreign_key: 'depositary_enrolle_code'

  before_validation :assign_only_the_codes

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

    self.related_varieties.scan(/\[(\d+)\]/).each do |code, _|
      self.variety_codes += [code.to_i] unless self.variety_codes.include?(code.to_i)
    end if self.related_varieties.present?

    if !self.depositary_enrolle_code &&
      (dep_code = self.related_depositary_enrolle.match(/\[(\w\d+)\]/))
      self.depositary_enrolle_code = dep_code[1]
    end

    if self.related_destiny.present?
      self.destiny_codes = self.related_destiny.split(',').map(&:to_i)
    end
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

  def varieties_blank?
    self.variety_codes.empty? && self.related_varieties.blank?
  end

  def destiny_blank?
    self.related_destiny.blank? && self.destiny_codes.nil?
  end

  def destroy
    self.deleted_at = Time.zone.now
    self.save!
  end

  def destinies
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
    self.variety_codes.map { |v| InvVariety.find(v).to_s }
  end
end
