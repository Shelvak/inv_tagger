class InvEnrolle < InvDbModel
  self.table_name = 'inscriptos'
  self.primary_key = 'nroins'

  has_magick_columns nroins: :string, nombre: :string

  def to_s
    "[#{self.nroins}] #{self.nombre}"
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
