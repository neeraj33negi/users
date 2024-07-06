## we don't want to start the app server unless a secret key is added
SECRET_API_KEY = Rails.application.secrets[:api_key]
if SECRET_API_KEY.blank?
  raise "Project needs a key"
end
