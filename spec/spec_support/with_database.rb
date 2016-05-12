DATABASE_CLASSES = %w( people )

# Create database
def create_database
  client = ArangoDB::Client.new
  client.uri.database = ''
  client.database.create('arangodb_api_test') unless client.database.exists?('arangodb_api_test')
end

# Drop database
def drop_database
  client = ArangoDB::Client.new
  client.uri.database = ''
  client.database.drop('arangodb_api_test') if client.database.exists?('arangodb_api_test')
end

# Create database classes
def create_database_classes
  endpoint = ArangoDB::Client.new.collection
  DATABASE_CLASSES.each do |collection|
    endpoint.create(collection) unless endpoint.exists?(collection)
  end
end

# Drop database classes
def clear_database_classes
  endpoint = ArangoDB::Client.new.collection
  DATABASE_CLASSES.each do |collection|
    endpoint.truncate(collection) if endpoint.exists?(collection)
  end
end

# Drop database classes
def drop_database_classes
  endpoint = ArangoDB::Client.new.collection
  DATABASE_CLASSES.each do |collection|
    endpoint.drop(collection) if endpoint.exists?(collection)
  end
end

RSpec.shared_context "with database", :with_database => true do
  before(:all)  { create_database }
  before(:all)  { create_database_classes }
  before(:each) { clear_database_classes }
  # after(:all)   { drop_database_classes }
  after(:all)   { drop_database }
end
