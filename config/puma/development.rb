threads 4, 4
workers 2

before_fork do
  ValidatedJSON::DB.disconnect if defined?(ValidatedJSON::DB)
end
