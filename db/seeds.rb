require 'yaml'
require_relative '../config/environment'

yaml_users = File.read(File.expand_path('seeds/users.yml', __dir__))
yaml_user_sessions = File.read(File.expand_path('seeds/user_sessions.yml', __dir__))

YAML.safe_load(yaml_users).each do |user_attrs|
  user = User.where(email: user_attrs.fetch('email')).all.first
  User.create(user_attrs) if user.nil?
end

YAML.safe_load(yaml_user_sessions).each do |user_session_attrs|
   user = User.where(email: user_session_attrs.fetch('email')).all.first
   user.add_user_session(uuid: SecureRandom.uuid)
end
