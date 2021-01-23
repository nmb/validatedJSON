require 'json'

def addSiblings(h, siblingKey, subh)
  h.each do |_key, value|
    addSiblings(value, siblingKey, subh) if value.instance_of?(Hash)
  end
  h.merge!(subh) if h.has_key?(siblingKey)
end
