require 'mongoid'
require 'json'
require 'json_schemer'

class Metaschema
  include Mongoid::Document
  include Mongoid::Timestamps
  field :jsonstr, type: String
  has_many :schemas

  validate :validjson

  def validjson
    jsonobj = JSON.parse(jsonstr)
    errors.add(:jsonstr, 'Data invalid') unless JSONSchemer.schema(jsonobj).valid?(jsonobj)
  end

end
