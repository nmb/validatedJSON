require 'mongoid'
class User 
  include Mongoid::Document
  field :uid, type: String
  field :username, type: String
  field :admin, type: Boolean, default: false
  field :editor, type: Boolean, default: false
  has_many :jsonobjects
  has_many :schemas
end
