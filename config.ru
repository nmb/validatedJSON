require File.expand_path('config/boot.rb', __dir__)
require Sinator::ROOT + '/validatedJSON'
require Sinator::ROOT + '/config/application'

use Rack::MethodOverride
run ValidatedJSON
