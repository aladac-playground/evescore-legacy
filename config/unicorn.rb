# config/unicorn.rb

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout Integer(ENV['WEB_TIMEOUT'] || 15)
preload_app true

if ENV['UNICORN_SOCKET']
	listen Dir.pwd + "/tmp/sockets/unicorn.sock", backlog: ( ENV['UNICORN_SOCKET_BACKLOG'] ? ENV['UNICORN_SOCKET_BACKLOG'] : 64 )
end

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end  

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
