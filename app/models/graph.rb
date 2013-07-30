class Graph
  include Mongoid::Document
  field :title, type: String
  field :data, type: String
  index({ title: 1 }, { unique: true, drop_dups: true })
end
