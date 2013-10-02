class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  validates :generated_at, :quantity, :harvest, presence: true

  ['enrolle', 'product', 'destiny'].each do |t|
    validates :"related_#{t}", presence: true, if: :"#{t}_blank?"
  end

  attr_accessor :related_enrolle, :related_product, :related_variety, 
    :related_destiny

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :variety, class_name: InvVariety, foreign_key: 'variety_code'
  belongs_to :destiny, class_name: InvDestiny, foreign_key: 'destiny_code'

  before_save :assign_only_the_codes

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

    if !self.destiny_code && (dest_code = self.related_destiny.match(/\[(\d+)\]/))
      self.destiny_code = dest_code[1]
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

  ['enrolle', 'product', 'variety', 'destiny'].each do |t|
    define_method("#{t}_blank?") do
      self.send("#{t}_code").blank? && self.send("related_#{t}").blank?
    end
  end

  def destroy
    self.deleted_at = Time.zone.now
    self.save!
  end
end
