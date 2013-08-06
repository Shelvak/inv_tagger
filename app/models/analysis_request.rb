class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  validates :related_enrolle, :related_product, :related_variety, :generated_at,
    :quantity, :related_destiny, :harvest, presence: true

  attr_accessor :related_enrolle, :related_product, :related_variety, 
    :related_destiny

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :variety, class_name: InvVariety, foreign_key: 'variety_code'
  belongs_to :destiny, class_name: InvDestiny, foreign_key: 'destiny_code'

  before_save :assign_only_the_codes
  #after_create :generate_cardboard

  def to_s
    self.enrolle
  end

  def assign_only_the_codes
    if enrol_code = self.related_enrolle.match(/\[(.+)\]/)
      self.enrolle_code = enrol_code[1]
    end

    if prod_code = self.related_product.match(/\[(\d+)\]/)
      self.product_code = prod_code[1]
    end

    if var_code = self.related_variety.match(/\[(\d+)\]/)
      self.variety_code = var_code[1]
    end

    if dest_code = self.related_destiny.match(/\[(\d+)\]/)
      self.destiny_code = dest_code[1]
    end
  end

  def generate_cardboard
    Printer.generate_cardboard(self)
  end
end
