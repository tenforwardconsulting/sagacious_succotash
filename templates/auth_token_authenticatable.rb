module AuthTokenAuthenticatable
  extend ActiveSupport::Concern

  included do
    after_save :ensure_auth_token!
  end

  private

  def ensure_auth_token!
    if auth_token.blank?
      update_column :auth_token, generate_auth_token
    end
  end

  def generate_auth_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by_auth_token(token)
    end
  end
end
