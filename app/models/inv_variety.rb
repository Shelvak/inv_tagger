class InvVariety < InvDbModel
  self.table_name = 'variedad'
  self.primary_key = 'codvar'

  has_magick_columns codvar: :string, design: :string

  alias_attribute :name, :design
  alias_attribute :code, :codvar

  def to_s
    "[#{self.codvar}] #{self.name.strip}"
  end

  alias_method :label, :to_s
  alias_method :id, :code

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:id, :label]
    }

    super(default_options.merge(options || {}))
  end
end
