class Feedback
  include Mongoid::Document
  include TimeTrackable

  field :browser, type: Hash
  field :url, type: String
  field :note, type: String
  field :img, type: String
  field :html, type: String

end