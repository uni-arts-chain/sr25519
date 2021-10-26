require "ed25519"
class ED25519
  
  ##
  # Sign the given message, Return sign result as hex string
  # ==== Examples
  #   message = "Hello world"
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   keypair = ED25519.keypair_from_seed(seed)
  #   signature_result = ED25519.sign(message, keypair)

  def self.sign(message, key_pair)
    "0x" + key_pair.sign(message).unpack1("H*")
  end

  ##
  # Verify the sign result, Return true or false
  # ==== Examples
  #   message = "Hello world"
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   public_key = ED25519.get_public_key_from_seed(seed)
  #   address = Address.encode(public_key)
  #   keypair = ED25519.keypair_from_seed(seed)
  #   signature_result = ED25519.sign(message, keypair)
  #   verify_result = ED25519.verify(address, message, signature_result)

  def self.verify(address, message, signature_result)
    if signature_result.start_with?("0x")
      signature_result = signature_result.sub(/0x/, "")
    end
    signature = [signature_result].pack("H*")
    public_key = Address.decode(address)
    verify_key_bytes = [public_key].pack("H*")
    verify_key  = Ed25519::VerifyKey.new(verify_key_bytes)
    begin
      verify_key.verify(signature, message)
    rescue
      return false
    end
  end

  ##
  # Generate ED25519 keypair
  # ==== Examples
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   keypair = ED25519.keypair_from_seed(seed)

  def self.keypair_from_seed(seed)
    if seed.start_with?("0x")
      seed = seed.sub(/0x/, "")
    end
    seed = "".tap { |binary| seed.scan(/../) { |hn| binary << hn.to_i(16).chr } }
    signing_key = Ed25519::SigningKey.new(seed)
    return signing_key
  end

  ##
  # Get ED25519 public key, return as hex string
  # ==== Examples
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   public_key = ED25519.get_public_key_from_seed(seed)

  def self.get_public_key_from_seed(seed)
    signing_key = self.keypair_from_seed(seed)
    return signing_key.verify_key.to_bytes.unpack1('H*')
  end

end