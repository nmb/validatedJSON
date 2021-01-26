helpers do
  def getUserId
    if u = session[:userid]
      u
    elsif request.env['HTTP_AUTHORIZATION']
      begin
        token = request.env['HTTP_AUTHORIZATION'].split.pop
        payload, header = JWT.decode token, settings.jwtsecret, true, { algorithm: 'HS256' }
        payload['userid']
      rescue StandardError
        "Error validating token"
      end
    end
  end

  def protected!
    redirect(to('/signin')) unless getUserId
  end

  def ownerprotected!(o)
    protected!
    halt 404, "Not found\n" unless o
    u = getUserId
    halt 401, "Not authorized\n" unless u == o.user || User.find(u).admin
  end

  def editorprotected!
    protected!
    u = getUserId
    halt 401, "Not authorized\n" unless User.find(u).editor || User.find(u).admin
  end

  def adminprotected!
    protected!
    u = getUserId
    halt 401, "Not authorized\n" unless User.find(u).admin
  end

  def generateJWT
    halt unless session[:userid]
    require 'jwt'
    exp = Time.now.to_i + 4 * 3600
    payload = { userid: session[:userid].to_s, exp: exp }
    JWT.encode payload, settings.jwtsecret, 'HS256'
  end
end
