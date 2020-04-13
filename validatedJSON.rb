require 'yaml'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'securerandom'

class ValidatedJSON < Sinatra::Application

  set :app_file, __FILE__
  set :server, :puma
  set :views, Proc.new { File.join(root, "app/views") }
  #use Rack::Csrf, raise: true

  session_secret = ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  use Rack::Session::Cookie, secret: session_secret
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    provider :google_oauth2, ENV["GOOGLEOAUTH2ID"], ENV["GOOGLEOAUTH2SECRET"],
    {
      scope: 'userinfo.email',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50
    }
  end

  configure do

    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))
    set :jwtsecret, ENV["JWT_SECRET"] || SecureRandom.urlsafe_base64(n=32)

  end

  configure :development do
    require 'sinatra/reloader'
    require 'logger'

    register Sinatra::Reloader

  end

  configure :production do
    # Serve assets via Nginx or Apache
    disable :static
  end


end
