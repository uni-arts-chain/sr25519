# frozen_string_literal: true

require_relative "sr25519/version"
require "address"
require "sr25519_lib"
require "ed25519_lib"

module Sr25519
  class Error < StandardError; end
end
