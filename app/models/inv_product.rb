class InvProduct < InvDbModel
  self.table_name = 'prodvini'
  self.primary_key = 'codpro'

  has_magick_columns codpro: :string, design: :string

  alias_attribute :name, :design

  def name
    Iconv.iconv('UTF-8', 'LATIN1', self.design.strip).join
  end

  def to_s
    "[#{self.codpro}] #{self.name}"
  end

  alias_method :label, :to_s
end
