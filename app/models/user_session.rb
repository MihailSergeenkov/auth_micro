class UserSession < Sequel::Model
  many_to_one :user

  def validate
    super
    validates_presence :uuid, message: I18n.t(:blank, scope: 'models.errors.user_session.uuid')
    validates_presence :user_id, message: I18n.t(:blank, scope: 'models.errors.user_session.user_id')
  end
end
