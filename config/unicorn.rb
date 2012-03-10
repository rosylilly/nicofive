worker_processes 4
working_directory File.join(File.dirname(__FILE__), '../')

port = ENV['PORT'] || 9292
listen port.to_i, :tcp_nopush => false

pid 'tmp/pids/unicorn.pid'
