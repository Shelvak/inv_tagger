class InvDestiny < InvDbModel
  self.table_name = 'paises'
  self.primary_key = 'codpais'

  has_magick_columns codpais: :string, nombre: :string

  default_scope -> { where("codpais != 0")  }

  def to_s
    "[#{self.codpais}] #{self.nombre}"
  end

  def code
    self.codpais
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
