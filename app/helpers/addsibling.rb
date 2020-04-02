require 'json'

def addSiblings(h, siblingKey, subh)
  h.each do |key, value|
    if(value.class == Hash)
      addSiblings(value, siblingKey, subh)
    end
  end
    if(h.has_key?(siblingKey)) 
      h.merge!(subh)
    end
end

