require "database_cleaner"

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.strategy = :deletion
  end

end
