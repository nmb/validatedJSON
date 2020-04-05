require 'mongoid'
require 'json'
require 'json_schemer'
require 'hashie'

class Schema
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String, default: ""
  field :jsonstr, type: String
  field :active, type: Boolean, default: false
  belongs_to :metaschema
  belongs_to :user
  has_many :jsonobjects

  before_validation :lockdown 
  validate :validjson
  validates_length_of :title, minimum: 3, maximum: 64
  validates_length_of :description, minimum: 0, maximum: 512

  def validjson
    schema = JSON.parse(jsonstr)
    schema.extend Hashie::Extensions::DeepFind
    errors.add(:jsonstr, 'References in schemas not supported.') if schema.deep_find("$ref")
    validator = JSONSchemer.schema(JSON.parse(metaschema.jsonstr))
    errors.add(:jsonstr, 'Data invalid') unless validator.valid?(schema)
  end

  protected
  def lockdown
    self.jsonstr = addSiblings(JSON.parse(jsonstr), "properties", 
                               {"additionalProperties" => false}).to_json
  end
end

