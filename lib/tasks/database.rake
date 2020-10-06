namespace :database do

  def seeded?
    begin
      service_alert = ServiceAlerts::Alert.all.first
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
    end
    if service_alert.present?
      true
    else
      false
    end
  end

  task :create_if_necessary => :environment do
    if seeded?
      Rails.logger.warn 'Database has already been seeded, will not run db:setup.'
    else
      Rails.logger.warn 'Database does not exist or has not been seeded, running db:setup...'
      Rake::Task['db:schema:load'].invoke
      if Rails.env != 'production'
        Rake::Task['db:seed'].invoke
      else
        Rails.logger.warn 'Production database has not been seeded - please import data as needed'
      end
    end
  end

  task :load_schema => :environment do
    if Rails.env == "test" and Rails.configuration.database_configuration['test']['adapter'] == 'sqlite3'
      load "#{Rails.root}/db/schema.rb"
      puts "SQLite database loaded from db/schema.rb"
    end
  end

end
