require 'spec_helper'
require 'database_cleaner'
require 'colorize'

# ------------------------------------------------------------
# ActiveRecord: database setup/teardown

if (env = ENV['RAILS_ENV'])
  abort("Can't run tests in environment #{env}") if env != 'test'
else
  ENV['RAILS_ENV'] = 'test'
end

# Always load the schema: https://relishapp.com/rspec/rspec-rails/docs/upgrade#pending-migration-checks
# TODO: do we need this if we're explicitly running migrations?
ActiveRecord::Migration.maintain_test_schema!

# Make sure we're not clobbering non-test data
def check_connection_config!
  db_config = ActiveRecord::Base.connection_config
  host = db_config[:host]
  raise("Can't run destructive tests against non-local database #{host || 'nil'}") unless host == 'localhost'
  msg = "Using database #{db_config[:database]} on host #{host} with username #{db_config[:username]}"
  puts msg.colorize(:yellow)
end

# Run migrations manually
def run_migrations!
  db_config = YAML.load_file('spec/config/database.yml')['test']
  ActiveRecord::Base.establish_connection(db_config)
  check_connection_config!

  paths = []
  ENGINES.values.each do |engine_path|
    migration_path = "#{engine_path}/db/migrate"
    paths << migration_path if File.directory?(migration_path)
  end

  puts "Executing migrations from:\n\t#{paths.join("\n\t")}"
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Migrator.up paths
end

# ------------------------------------------------------------
# Rspec configuration

RSpec.configure do |config|
  config.before(:suite) do
    run_migrations!

    DatabaseCleaner.strategy = :deletion
    puts 'Clearing test database'.colorize(:yellow)
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# ------------------------------------------------------------
# Stash

# TODO: cleanly separate test-safe and test-unsafe initializers
stash_engine_path = ENGINES['stash_engine']
%w[hash_to_ostruct inflections].each do |initializer|
  require "#{stash_engine_path}/config/initializers/#{initializer}.rb"
end

LICENSES = YAML.load_file(File.expand_path('../config/licenses.yml', __FILE__)).with_indifferent_access

# TODO: stop needing to do this
module StashDatacite
  @@resource_class = 'StashEngine::Resource' # rubocop:disable Style/ClassVars
end

# TODO: stop needing to do these things
stash_datacite_path = ENGINES['stash_datacite']
require "#{stash_datacite_path}/config/initializers/patches.rb"
StashDatacite::ResourcePatch.associate_with_resource(StashEngine::Resource)