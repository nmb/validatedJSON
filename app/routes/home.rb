class ValidatedJSON
  get '/' do
    erb :"home/index"
  end
  get "/logout" do
    logger.info "Logout: #{session[:name]}\n"
    session[:userid] = nil
    session[:name] = nil
    redirect to('/')
  end
  get '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    if(auth.valid?)
      uid = auth['provider']+':'+ auth['uid']
      unless(User.where(uid: uid).exists?)
        User.create!(:uid => uid, :username => auth['info'].name)
        logger.info "New user: #{auth['info'].name}\n"
      end
      u = User.find_by(uid: uid)
      session[:userid] = u.id
      session[:name] = u.username
      logger.info "Login: #{auth['info'].name}\n"
    end
    redirect to('/')
  end
  get '/profile' do
    if(session[:userid])
      erb :"home/profile"
    else
      redirect to('/')
    end
  end
  get '/profile/token' do
    if(session[:userid])
    content_type "application/jwt"  
    generateJWT
    else
      redirect to('/')
    end
  end
  get '/signin' do
    erb :"home/signin"
  end
  get '/cookiesinfo' do
    session[:cookiesInfo] = true
  end
end
