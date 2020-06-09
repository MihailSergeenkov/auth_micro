class User < Sequel::Model
  NAME_FORMAT = %r{\A\w+\z}

  plugin :secure_password, include_validations: false

  one_to_many :user_sessions

  def validate
    super
    validates_presence :name, message: I18n.t(:blank, scope: 'models.errors.user.name')
    validates_format NAME_FORMAT, :name, message: I18n.t(:format, scope: 'models.errors.user.name')
    validates_presence :email, message: I18n.t(:blank, scope: 'models.errors.user.email')
    validates_presence :password_digest, message: I18n.t(:blank, scope: 'models.errors.user.password_digest')
  end
end
