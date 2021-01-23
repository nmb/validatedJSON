require_relative 'config/boot'
require_relative 'validatedJSON'

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    manifest = ::Sprockets::Manifest.new(ValidatedJSON.assets.index, "#{ValidatedJSON.public_folder}/assets")
    manifest.compile(ValidatedJSON.assets_manifest)
  end

  desc 'Clean assets'
  task :clean do
    FileUtils.rm_rf("#{ValidatedJSON.public_folder}/assets")
  end
end

namespace :db do
  desc 'Drop database'
  task :drop do
    system('mongo validatedJSON_development --eval "printjson(db.dropDatabase())"')
  end
  desc 'List users'
  task :listusers do
    require Sinator::ROOT + '/config/application'
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))
    User.all.each { |u| print JSON.pretty_generate(JSON.parse(u.to_json)) }
  end
  desc 'Set admin'
  task :setadmin, [:uid] do |_t, args|
    require Sinator::ROOT + '/config/application'
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))
    u = User.find(args[:uid])
    u['admin'] = true
    u.save
  end
end
