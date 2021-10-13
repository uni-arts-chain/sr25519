require "ed25519"
class ED25519
  
  # Creates a signature for given data
  def self.sign(message, key_pair)
    "0x" + key_pair.sign(message).unpack1("H*")
  end

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

  def self.keypair_from_seed(seed)
    if seed.start_with?("0x")
      seed = seed.sub(/0x/, "")
    end
    seed = "".tap { |binary| seed.scan(/../) { |hn| binary << hn.to_i(16).chr } }
    signing_key = Ed25519::SigningKey.new(seed)
    return signing_key
  end

  def self.get_public_key_from_seed(seed)
    signing_key = self.keypair_from_seed(seed)
    return signing_key.verify_key.to_bytes.unpack1('H*')
  end

end