module UsersHelper


  # Used to access the stored API key for the current user
  def api_key
    current_user.api_key
  end

end
