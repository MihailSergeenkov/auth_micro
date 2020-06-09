class AuthRoutes < Application
  namespace '/v1' do
    namespace '/users' do
      post do
        user_params = validate_with!(UserParamsContract)[:user]

        result = Users::CreateService.call(
          user_params[:name],
          user_params[:email],
          user_params[:password]
        )

        if result.success?
          status 201
        else
          status 422
          error_response result.user
        end
      end
    end

    namespace '/user_sessions' do
      post do
        user_session_params = validate_with!(UserSessionParamsContract)[:user_session]

        result = UserSessions::CreateService.call(
          user_session_params[:email],
          user_session_params[:password]
        )

        if result.success?
          token = JwtEncoder.encode(uuid: result.session.uuid)
          meta = { token: token }

          status 201
          json(meta: meta)
        else
          status 422
          error_response result.session
        end
      end
    end
  end
end
