class InvProduct < InvDbModel
  self.table_name = 'prodvini'
  self.primary_key = 'codpro'

  has_magick_columns codpro: :string, design: :string

  def to_s
    "[#{self.codpro}] #{self.design}"
  end

  alias_method :label, :to_s
end
