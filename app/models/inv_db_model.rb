class InvDbModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "inv_db"

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
