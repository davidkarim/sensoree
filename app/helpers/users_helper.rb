module UsersHelper

  # Used to generate a 20 digit alphanumeric API key
  def generate_api
    alpha = ('A'..'Z').to_a
    alphanum = alpha + ('0'..'9').to_a
    api_key = alpha.sample
    19.times do
      api_key += alphanum.sample
    end
    api_key
  end

  # Used to access the stored API key for the current user
  def api_key
    current_user.api_key
  end

end
