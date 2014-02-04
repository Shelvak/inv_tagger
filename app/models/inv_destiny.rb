class InvDestiny < InvDbModel
  self.table_name = 'paises'
  self.primary_key = 'codpais'

  $europa_obj = new(codpais: 99999, nombre: 'MERCADO COMUN EUROPEO', desred: 'M.C.E.')

  has_magick_columns codpais: :string, nombre: :string

  default_scope -> { where("codpais != 0")  }

  alias_attribute :name, :nombre

  def name
    Iconv.iconv('UTF-8', 'LATIN1', self.nombre.strip.gsub(/\W+/, ' ')).join
  end

  def to_s
    if self.codpais == 99999
      "[#{self.desred}] #{self.name}"
    else
      "[#{self.codpais}] #{self.name}"
    end
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

  def self.filtered_list(query)
    if query.to_s.match(/mce|#{$europa_obj.nombre}/i)
      [$europa_obj]
    else
      query.present? ? magick_search(query) : scoped
    end
  end

  def form_code
    self.codpais == 99999 ? 'M.C.E.' : self.codpais
  end
end
