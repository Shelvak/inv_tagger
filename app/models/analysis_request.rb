class AnalysisRequest < ActiveRecord::Base
  has_paper_trail

  validates :enrolle, :product, :variety, :generated_at, presence: true

  def to_s
    self.enrolle_name
  end

  def enrolle_name
    self.enrolle #temp
  end
end
