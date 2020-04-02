class ValidatedJSON
  get '/schemas/?' do
    @schemas = Schema.all
    erb :"schemas/index"
  end
  get '/schemas/new' do
    erb :"schemas/new"
  end
  get '/schemas/:schema_id' do |schema_id|
    begin
    @schema = Schema.find(schema_id)
    if(params["format"] == "json" || request.preferred_type().to_s == "application/json")
      @schema.jsonstr
    else
      erb :"schemas/view"
    end
    rescue
      404
    end
  end
  post '/schemas' do
    editorprotected!
    params["title"] = Sanitize.clean(params["title"])
    params["description"] = Sanitize.clean(params["description"])
    if(params["jsonstr"] && params["title"])
      s = Schema.create!(params.merge({:metaschema => Metaschema.all.first(), :user=>session["userid"]}))
    else
      s = Schema.create!({:title => params["title"], 
                         :description => params["description"], 
                         :jsonstr => File.open(params[:jsonstrfile][:tempfile]).read, 
                         :metaschema => Metaschema.all.first(),
                         :user=>session["userid"]})
    end
    s.save
    redirect "/schemas/#{s.id}"
  end
  delete '/schemas/:schema_id/?' do |schema_id|
    begin
      @schema = Schema.find(schema_id)
      ownerprotected!(@schema)
    rescue
      404
    end
    @schema.destroy
    redirect('/schemas/')
  end

end
