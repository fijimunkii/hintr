Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ENV['HINTR_RESQUE_PASSWORD']
end
