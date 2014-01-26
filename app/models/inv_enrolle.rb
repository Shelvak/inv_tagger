class InvEnrolle < InvDbModel
  self.table_name = 'inscriptos'
  self.primary_key = 'nroins'

  has_magick_columns nroins: :string, nombre: :string

  alias_attribute :name, :nombre
  def name
    Iconv.iconv('UTF-8', 'LATIN1', self.nombre.try(:strip)).join
  end

  def to_s
    "[#{self.nroins}] #{self.name}"
  end

  alias_method :label, :to_s
end
