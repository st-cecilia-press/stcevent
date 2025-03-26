Clearance.configure do |config|
  config.routes = false
  config.allow_sign_up = false
  # we aren't planning to send mails
  config.mailer_sender = "nobody@default.invalid"
  config.rotate_csrf_on_sign_in = true
  config.signed_cookie = true
end
