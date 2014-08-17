# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
AnimeOpQuiz::Application.config.secret_token = '9d76ad8cc22f5fa9eb0599af391aa6814d5c868f37415c747888f293ea374fb8b8b382954fadcdb9e185db87972a2c30782cff7e31b10a3d15e569b2e11cb159'

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end