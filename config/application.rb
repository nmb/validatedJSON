%w{/app/models /app/helpers /app/routes}.each do |dir|
  resource_dir = Sinator::ROOT + dir

  Dir[File.join(resource_dir, '**/*.rb')].each do |file|
    require file
  end
end

if(Metaschema.empty?)
  print "Obtaining metaschema\n"
  msstr = Net::HTTP.get(URI("http://json-schema.org/draft-04/schema#"))
  m = Metaschema.create(:jsonstr => msstr)
  m.save
end

