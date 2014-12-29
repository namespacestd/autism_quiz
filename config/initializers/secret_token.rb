# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
AnimeOpQuiz::Application.config.secret_token = 'c87a4ff3512e88be72453b69d3795499c1a650c22d311205fdb60cbbf9a8ccf1ee51c868d8da020f74804e7dbbe2afb546b4f8cb17ad107cdbcc23e4ac0a6898'

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end