require 'mongoid'
require 'json'
require 'json-schema'
require 'hashie'
require 'irb'

class Schema
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String, default: ''
  field :jsonstr, type: String
  field :public, type: Boolean, default: false
  belongs_to :metaschema
  belongs_to :user
  has_many :jsonobjects

  #before_validation :lockdown
  validate :validjson
  validates_length_of :title, minimum: 3, maximum: 64
  validates_length_of :description, minimum: 0, maximum: 512

  def validjson
    schema = JSON.parse(jsonstr)
    schema.extend Hashie::Extensions::DeepFind
    if schema.deep_find_all('$ref').to_a.any? { |r| r.class == String && r !~ /^#/ }
      errors.add(:jsonstr, 'External references in schemas not supported.')
    end
    metaschema = JSON::Validator.validator_for_name("draft4").metaschema
    errors.add(:jsonstr, 'Data invalid') unless JSON::Validator.validate(metaschema, jsonstr)
  end

  protected

  def lockdown
    self.jsonstr = addSiblings(JSON.parse(jsonstr), 'properties',
                               { 'additionalProperties' => false }).to_json
  end
end
