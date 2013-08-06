class InvDestiny < InvDbModel
  self.table_name = 'paises'
  self.primary_key = 'codpais'

  has_magick_columns codpais: :string, nombre: :string

  default_scope -> { where("codpais != 0")  }

  def to_s
    "[#{self.codpais}] #{self.nombre}"
  end

  alias_method :label, :to_s
end
