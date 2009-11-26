class DynamicAttributesMigrationGenerator < Rails::Generator::Base 
  def manifest 
    record do |m| 
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "dynamic_attributes_migration"
    end
  end
end