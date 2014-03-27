Clearance.configure do |config|
  config.mailer_sender = ''
  config.mailer_sender = ENV["ADMIN_EMAIL"]
  config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  config.cookie_path = '/'
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.allow_sign_up = true
end