class InvVariety < InvDbModel
  self.table_name = 'variedad'
  self.primary_key = 'codvar'

  has_magick_columns codvar: :string, design: :string

  def to_s
    "[#{self.codvar}] #{self.design}"
  end

  alias_method :label, :to_s
end
