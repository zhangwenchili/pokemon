# Real outbound email when SMTP_* env vars are set (works locally via .env and on Heroku via config vars).
# Example providers: SendGrid (Heroku add-on), Mailgun, Amazon SES, Postmark, or Gmail with an app password.
smtp_address = ENV["SMTP_ADDRESS"].presence
smtp_password = ENV["SMTP_PASSWORD"].presence

if smtp_address && smtp_password
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.perform_deliveries = true

  Rails.application.config.action_mailer.smtp_settings = {
    address: smtp_address,
    port: ENV.fetch("SMTP_PORT", "587").to_i,
    domain: ENV.fetch("SMTP_DOMAIN", "localhost").to_s,
    user_name: ENV["SMTP_USER_NAME"].presence || ENV["SMTP_USERNAME"].presence,
    password: smtp_password,
    authentication: ENV.fetch("SMTP_AUTHENTICATION", "plain").to_sym,
    enable_starttls_auto: !%w[0 false no].include?(ENV.fetch("SMTP_ENABLE_STARTTLS_AUTO", "true").downcase)
  }.compact

  if Rails.env.development?
    Rails.application.config.action_mailer.raise_delivery_errors = true
  end

  if Rails.env.production? && ENV["SMTP_RAISE_DELIVERY_ERRORS"] == "true"
    Rails.application.config.action_mailer.raise_delivery_errors = true
  end
end
