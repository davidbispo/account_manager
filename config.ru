Dir[File.join(__dir__, 'app', '**', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'db', 'connections', '**', '*.rb')].each { |file| require_relative file }
run AccountManager::API.new