class InvEnrolle < InvDbModel
  self.table_name = 'inscriptos'
  self.primary_key = 'nroins'

  has_magick_columns nroins: :string, nombre: :string

  def to_s
    "[#{self.nroins}] #{self.nombre.strip}"
  end

  alias_method :label, :to_s
end
