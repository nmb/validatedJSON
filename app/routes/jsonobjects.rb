class ValidatedJSON
  get '/jsonobjects/?' do
    @jsonobjects = Jsonobject.where(user: getUserId)
    if params['format'] == 'json' || request.preferred_type.to_s == 'application/json'
      JSON.pretty_generate(JSON.parse(@jsonobjects.to_json))
    else
      erb :"jsonobjects/index"
    end
  end
  get '/jsonobjects/new/?' do
    begin
      schema = Schema.find(params[:schema])
      p schema.title
      @jsonobject = Jsonobject.new
      @jsonobject.schema = schema
      erb :"jsonobjects/edit"
    rescue StandardError => e
      p e
      404
    end
  end
  get '/jsonobjects/:jsonobject_id/?' do |jsonobject_id|
    begin
      @jsonobject = Jsonobject.find(jsonobject_id)
      ownerprotected!(@jsonobject) unless @jsonobject.public
      if params['format'] == 'json' || request.preferred_type.to_s == 'application/json'
        JSON.pretty_generate(JSON.parse(@jsonobject.to_json))
      else
        erb :"jsonobjects/view"
      end
    rescue StandardError => e
      logger.info e
      404
    end
  end
  get '/jsonobjects/:jsonobject_id/edit/?' do |jsonobject_id|
    begin
      @jsonobject = Jsonobject.find(jsonobject_id)
      logger.info @jsonobject
      ownerprotected!(@jsonobject)
      erb :"jsonobjects/edit"
    rescue StandardError => e
      logger.info e
      404
    end
  end
  post '/jsonobjects/?' do
    protected!
    user = getUserId
    j = Jsonobject.create!(schema: params[:schema],
                           jsonstr: JSON.parse(params[:jsonstr]),
                           title: Sanitize.clean(params[:title]),
                           user: user)
    j.save!
    redirect('/jsonobjects/' + j.id)
  end
  put '/jsonobjects/:jsonobject_id/?' do |jsonobject_id|
    begin
      @jsonobject = Jsonobject.find(jsonobject_id)
      ownerprotected!(@jsonobject)
      @schema = Schema.find(params[:schema])
    rescue StandardError
      404
    end
    # clean parameters
    cleanParams = {}
    cleanParams[:title] = Sanitize.clean(params[:title])
    cleanParams[:schema] = params[:schema]
    cleanParams[:jsonstr] = JSON.parse(params[:jsonstr])
    cleanParams[:public] = params[:public] ? true : false
    @jsonobject.update_attributes(cleanParams)
    @jsonobject.save!
    redirect('/jsonobjects/' + @jsonobject.id)
  end
  delete '/jsonobjects/:jsonobject_id/?' do |jsonobject_id|
    begin
      @jsonobject = Jsonobject.find(jsonobject_id)
      ownerprotected!(@jsonobject)
    rescue StandardError
      404
    end
    @jsonobject.destroy
    redirect('/jsonobjects/')
  end
end
