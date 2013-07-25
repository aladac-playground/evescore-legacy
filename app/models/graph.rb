class Graph
  include Mongoid::Document
  field :title, type: String
  field :data, type: Hash 
end
