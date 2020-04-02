helpers do
  def getUserId
    if u = session[:userid]
      return u
    elsif request.env["HTTP_AUTHORIZATION"]
      begin
        token = request.env["HTTP_AUTHORIZATION"].split.pop
        payload, header = JWT.decode token, settings.jwtsecret, true, { algorithm: 'HS256' }
        return payload["userid"]
      rescue
        return nil
      end
    else
      return nil
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
    halt 401, "Not authorized\n" unless User.find(session[:userid]).editor || User.find(session[:userid]).admin
  end
  def adminprotected!
    protected!
    halt 401, "Not authorized\n" unless User.find(session[:userid]).admin
  end
  def generateJWT
    halt unless session[:userid]
    require 'jwt'
    hmac_secret = "secret"
    exp = Time.now.to_i + 4 * 3600
    payload = { userid: session[:userid], exp: exp }
    JWT.encode payload, settings.jwtsecret, 'HS256'
  end

end
