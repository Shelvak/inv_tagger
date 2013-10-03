class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  validates :generated_at, :quantity, :harvest, presence: true
  validates :harvest, numericality: { 
    allow_blank: true, allow_nil: true,
    greater_than_or_equal_to: 1500,
    less_than_or_equal_to: ->(d) { Date.today.year }
  }

  ['enrolle', 'product', 'destiny'].each do |t|
    validates :"related_#{t}", presence: true, if: :"#{t}_blank?"
  end

  attr_accessor :related_enrolle, :related_product, :related_variety, 
    :related_destiny

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :variety, class_name: InvVariety, foreign_key: 'variety_code'

  before_validation :assign_destiny_codes, :assign_only_the_codes

  def to_s
    self.enrolle
  end

  def assign_only_the_codes
    if !self.enrolle_code && (enrol_code = self.related_enrolle.match(/\[(.+)\]/))
      self.enrolle_code = enrol_code[1]
    end

    if !self.product_code && (prod_code = self.related_product.match(/\[(\d+)\]/))
      self.product_code = prod_code[1]
    end

    if !self.variety_code && (var_code = self.related_variety.match(/\[(\d+)\]/))
      self.variety_code = var_code[1]
    end
  end

  def assign_destiny_codes
    if self.related_destiny.present?
      self.destiny_codes = self.related_destiny.split(',').map(&:to_i)
    end
  end

  def generate_cardboard
    Printer.generate_cardboard(self)
  end

  def file_path
    Rails.root.join('tmp', 'to_print', "#{self.try(:id)}.pdf").to_s
  end

  def deleted?
    self.deleted_at.present?
  end

  ['enrolle', 'product', 'variety'].each do |t|
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
    InvDestiny.where(codpais: self.destiny_codes)
  end

  def destinies=(codes)
    self.destiny_codes = codes.sort
  end
end
