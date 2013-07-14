class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  validates :enrolle_code, :product_code, :variety_code, :generated_at, 
    presence: true

  belongs_to :enrolle, class_name: InvEnrolle, foreign_key: 'enrolle_code'
  belongs_to :product, class_name: InvProduct, foreign_key: 'product_code'
  belongs_to :variety, class_name: InvVariety, foreign_key: 'variety_code'

  before_save :assign_only_the_codes

  def to_s
    self.enrolle
  end

  def assign_only_the_codes
    if match_code = self.enrolle_code.match(/\[(.+)\]/)
      self.enrolle_code = match_code[1]
    end
  end
end
