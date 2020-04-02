require 'mongoid'
require 'json'
require 'json_schemer'

class Jsonobject
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String, default: ""
  field :jsonstr, type: Hash
  field :public, type: Boolean, default: false
  
  belongs_to :schema
  belongs_to :user

  validates_length_of :title, minimum: 1, maximum: 64
  validate :validjson

  def validjson
    validator = JSONSchemer.schema(JSON.parse(schema.jsonstr))
    errors.add(:jsonstr, 'Data invalid') unless validator.valid?(jsonstr)
  end
end
