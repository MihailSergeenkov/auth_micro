class UserSessionParamsContract < Dry::Validation::Contract
  params do
    required(:user_session).hash do
      required(:email).value(:string)
      required(:password).value(:string)
    end
  end
end
