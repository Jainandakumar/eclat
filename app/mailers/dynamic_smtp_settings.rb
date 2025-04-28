class DynamicSmtpSettings

	EMAILS = {
		'merch@banumathiexports.com' => {
			password: 'rhddzdjkkufunkpb'
		}
	}

	def self.smtp_settings(email)
    {
      address:              'smtp.gmail.com',
      port:                 '587',
      domain:               'gmail.com',
      user_name:            email,
      password:             DynamicSmtpSettings::EMAILS[email][:password],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end

end