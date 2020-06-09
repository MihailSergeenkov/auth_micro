RSpec.describe AuthRoutes, type: :routes do
  describe 'POST /v1/users' do
    context 'missing parameters' do
      it 'returns an error' do
        post '/v1/users'

        expect(last_response.status).to eq 422
      end
    end

    context 'invalid parameters' do
      let(:user_params) do
        {
          name: 'Vasya',
          email: 'vasya@test.ru',
          password: nil
        }
      end

      it 'returns an error' do
        post '/v1/users', user: user_params

        expect(last_response.status).to eq 422
        expect(response_body['errors']).to eq(
          [
            { 'detail' => 'В запросе отсутствуют необходимые параметры' }
          ]
        )
      end
    end

    context 'valid parameters' do
      let(:user_params) do
        {
          name: 'Vasya',
          email: 'vasya@test.ru',
          password: '12345678'
        }
      end

      it 'creates a new user' do
        expect { post '/v1/users', user: user_params }
          .to change { User.count }.from(0).to(1)
      end

      it 'returns status 201' do
        post '/v1/users', user: user_params

        expect(last_response.status).to eq 201
      end
    end
  end

  describe 'POST /v1/user_sessions' do
    let!(:user) do
      create(
        :user,
        email: 'vasya@test.ru',
        password: '12345678'
      )
    end

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1/user_sessions'

        expect(last_response.status).to eq 422
      end
    end

    context 'invalid parameters' do
      let(:user_session_params) do
        {
          email: 'vasya@test.ru',
          password: nil
        }
      end

      it 'returns an error' do
        post '/v1/user_sessions', user_session: user_session_params

        expect(last_response.status).to eq 422
        expect(response_body['errors']).to eq(
          [
            { 'detail' => 'В запросе отсутствуют необходимые параметры' }
          ]
        )
      end
    end

    context 'valid parameters' do
      let(:user_session_params) do
        {
          email: 'vasya@test.ru',
          password: '12345678'
        }
      end

      let(:last_user_session) { UserSession.last }
      let(:session_token) { JwtEncoder.encode(uuid: last_user_session.uuid) }

      it 'creates a new user session' do
        expect { post '/v1/user_sessions', user_session: user_session_params }
          .to change { UserSession.count }.from(0).to(1)
      end

      it 'returns status 201' do
        post '/v1/user_sessions', user_session: user_session_params

        expect(last_response.status).to eq 201
      end

      it 'returns a token' do
        post '/v1/user_sessions', user_session: user_session_params

        expect(response_body).to eq(
          'meta' => {
            'token' => session_token
          }
        )
      end
    end
  end
end
