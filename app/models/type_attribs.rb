class TypeAttribs < ActiveRecord::Base
  validates_uniqueness_of :type_id, scope: :name
end
