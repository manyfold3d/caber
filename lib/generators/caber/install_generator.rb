require "rails/generators"
require "rails/generators/active_record"

class Caber::InstallGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates/install", __dir__)

  class_option :database, type: :string, aliases: %i[--db], desc: "The database for your migration. By default, the current environment's primary database is used."
  class_option :skip_migrations, type: :boolean, default: nil, desc: "Skip migrations"

  def create_initializer_file
    copy_file "initializers/caber.rb", "config/initializers/caber.rb"
  end

  def create_migration_file
    return if options[:skip_migrations]

    migration_template "migrations/01_create_caber_relations.rb.erb", File.join("db/migrate/create_caber_relations.rb")
  end

  private

  def migration_version
    "[#{ActiveRecord::VERSION::STRING.to_f}]"
  end
end
