Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clever, '1da85a8592e00bdb1240', 'ca5cadf1b610e4c37cb838279c9a3bdb3c8bf1cc'
end