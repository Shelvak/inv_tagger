class InvDbModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "inv_db"
end
