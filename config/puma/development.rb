threads 4, 4
workers 2
preload_app!

before_fork do
  ValidatedJSON::DB.disconnect if defined?(ValidatedJSON::DB)
end