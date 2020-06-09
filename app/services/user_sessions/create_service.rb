module UserSessions
  class CreateService
    prepend BasicService

    param :email
    param :password
    option :user,
           default: proc { User.where(email: @email).all.first },
           reader: false

    attr_reader :session

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      return fail_t!(:unauthorized) unless @user&.authenticate(@password)
    end

    def create_session
      @session = @user.add_user_session(uuid: SecureRandom.uuid)
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.user_sessions.create_service'))
    end
  end
end
