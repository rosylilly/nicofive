class Application < Sinatra::Base
  set :sprockets, Sprockets::Environment.new

  redis_uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379/')
  set :redis, Redis.new(:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password)

  configure do
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = '/assets'
      config.digest = true
    end
    sprockets.append_path 'assets/javascripts'
    sprockets.append_path 'assets/stylesheets'

    sprockets.append_path 'vender/javascripts'
    sprockets.append_path 'vender/stylesheets'

    if ENV['RACK_ENV'] == 'production'
      sprockets.js_compressor = Closure::Compiler.new(:compilation_level => 'ADVANCED_OPTIMIZATIONS')
    end

    sprockets.cache = Sprockets::Cache::RedisStore.new(redis, 'sprockets')
  end

  helpers Sprockets::Helpers

  get '/' do
    haml :index
  end

  get '/install.user.js' do
    content = erb(:install_prefix) + coffee(erb(:"install.coffee"))
    content_type 'application/javascript'
    return content
  end
end
