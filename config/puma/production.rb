environment 'production'
pidfile './tmp/pids/puma.pid'
ctl_socket = './tmp/sockets/pumactl.sock'
state_path './tmp/sockets/puma.state'
quiet

threads 5, 5
workers 2

before_fork do
  ValidatedJSON::DB.disconnect if defined?(ValidatedJSON::DB)
end
