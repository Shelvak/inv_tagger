class InvVariety < InvDbModel
  self.table_name = 'variedad'
  self.primary_key = 'codvar'

  has_magick_columns codvar: :string, design: :string

  alias_attribute :name, :design
  alias_attribute :code, :codvar

  def to_s
    "[#{self.code}] #{self.name}"
  end

  alias_method :label, :to_s
end
