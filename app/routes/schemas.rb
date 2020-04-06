class ValidatedJSON
  get '/schemas/?' do
    uid = getUserId
    if(uid)
      user = User.find(uid)
      if(user.admin)
        @schemas = Schema.all
      else
        @schemas = Schema.where(public: true).union.where(user: user)
      end
    else
      @schemas = Schema.where(public: true)
    end
    erb :"schemas/index"
  end
  get '/schemas/new' do
    erb :"schemas/new"
  end
  get '/schemas/:schema_id' do |schema_id|
    begin
    @schema = Schema.find(schema_id)
    ownerprotected!(@schema) unless @schema.public
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
    cleanParams = {}
    cleanParams["title"] = Sanitize.clean(params["title"])
    cleanParams["description"] = Sanitize.clean(params["description"])
    cleanParams[:public] = params[:public] ? true : false
    cleanParams.merge!({:metaschema => Metaschema.all.first()})
    cleanParams.merge!({:user => getUserId })
    # jsonstr either as part of POST, or via file upload
    if(params["jsonstr"])
      s = Schema.create!(cleanParams.merge({:jsonstr => params["jsonstr"]}))
    else
      s = Schema.create!(cleanParams.merge({:jsonstr => File.open(params[:jsonstrfile][:tempfile]).read}))
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
