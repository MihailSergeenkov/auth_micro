namespace :db do
  desc 'Run database migrations'
  task :migrate, %i[version] => :settings do |t, args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
    end

    Rake::Task['db:schema_dump'].invoke
  end

  desc 'Run database schema dump'
  task :schema_dump, %i[version] => :settings do |t, args|
    require 'terrapin'

    db = Settings.db
    postgresql = "postgresql://#{db.user}:#{db.password}@#{db.host}/#{db.database}"
    command = Terrapin::CommandLine.new(
      'bin/sequel',
      "-D #{postgresql} > db/schema.rb"
    )

    command.run
  end

  desc 'Run database seed'
  task :seed, %i[version] => :settings do |t, args|
    load File.expand_path('../../db/seeds.rb', __dir__)
  end
end
