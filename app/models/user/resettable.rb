module User::Resettable
  extend ActiveSupport::Concern

  included do
    generates_token_for :password_reset, expires_in: 15.minutes do
      password_salt&.last(12)
    end
  end

  def password_reset_requested
    UserMailer.with(user: self, token: generate_token_for(:password_reset))
              .password_reset
              .deliver_later
  end
end
