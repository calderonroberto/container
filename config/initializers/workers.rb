Container::Application.configure do
 #clear workers before starting app
 Resque.workers.each {|w| w.unregister_worker}
end
