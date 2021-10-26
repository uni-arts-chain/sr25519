require 'ffi'
require 'address'
module SR25519Lib
  extend FFI::Library
 
  ffi_lib FFI::Library::LIBC

  ffi_lib File.dirname(__FILE__) + '/libsr25519crust.so' if RUBY_PLATFORM =~ /linux/
  ffi_lib File.dirname(__FILE__) + '/libsr25519crust.dylib' if RUBY_PLATFORM =~ /darwin/

  attach_function :sr25519_keypair_from_seed, [:pointer, :pointer], :void
  attach_function :sr25519_verify, [:pointer, :pointer, :uint, :pointer], :bool
  attach_function :sr25519_sign, [:pointer, :pointer, :pointer, :pointer, :uint], :void

end

class KeyPair < FFI::Struct
  # [32b key | 32b nonce | 32b public]
  layout :String, [:uint8, 96]

  ##
  # Return the keypair public key
  def public_key
    pub_key = self[:String].to_a[64..96]
    public_key = PublicKey.new
    public_key[:String].to_ptr.write_array_of_uint8(pub_key)
    public_key
  end

  def to_s
    self[:String].to_a.pack("c*").unpack1("H*")
  end
end

class Seed < FFI::Struct
  layout :String, [:uint8, 32]
end

class PublicKey < FFI::Struct
  layout :String, [:uint8, 32]

  def to_s
    self[:String].to_a.pack("c*").unpack1("H*")
  end
end

def sercet_key; end

def nonce ; end


class Signature < FFI::Struct
  layout :String, [:uint8, 64]
end

class SigMessage < FFI::Struct
  layout :String, [:uint8, 64]

  ##
  # Return the sign message as hex string
  def to_s
    self[:String].to_a.pack("c*").unpack1("H*")
  end
end

class SR25519

  # Sign message
  # @param message [String] message
  # @param private_key [String] private_key
  # @return [String] sign result
  # @example
  #   message = "Hello World"
  #   private_key = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   signature_result = SR25519.sr25519_sign(message, private_key)
  def self.sr25519_sign(message, private_key)
    sig = SigMessage.new
    msg = FFI::MemoryPointer.from_string(message)
    key_pair = self.keypair_from_seed(private_key)
    public_key = key_pair.public_key
    SR25519Lib.sr25519_sign(sig, public_key, key_pair, msg, message.length)
    sig.to_s
  end

  # Sign message
  # @param message [String] message
  # @param key_pair [KeyPair] Sr25519 keypair
  # @return [String] sign result
  # @example
  #   message = "Hello World"
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   keypair = SR25519.keypair_from_seed(seed)
  #   signature_result = SR25519.sign(message, keypair)
  def self.sign(message, key_pair)
    sig = SigMessage.new
    msg = FFI::MemoryPointer.from_string(message)
    public_key = key_pair.public_key
    SR25519Lib.sr25519_sign(sig, public_key, key_pair, msg, message.length)
    sig.to_s
  end

  # Verify the sign
  # @param address [String] account address
  # @param message [String] message
  # @param signature_result [String] Sr25519 sign result
  # @return [boolean] sign result
  # @example
  #   message = "Hello World"
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   keypair = SR25519.keypair_from_seed(seed)
  #   public_key = SR25519.get_public_key_from_seed(seed)
  #   address = Address.encode(public_key.to_s)
  #   signature_result = SR25519.sign(message, keypair)
  #   verify_result = SR25519.verify(address, message, signature_result)
  def self.verify(address, message, signature_result)
    pk = PublicKey.new
    public_key = self.decode_address(address)
    public_key = [public_key].pack("H*").unpack("C*")
    pk[:String].to_ptr.write_array_of_uint8(public_key)

    msg = FFI::MemoryPointer.from_string(message)
    sig = Signature.new
    if signature_result.start_with?("0x")
      signature_result = signature_result.sub(/0x/, "")
    end
    signature_result = [signature_result].pack("H*").unpack("C*")
    sig[:String].to_ptr.write_array_of_uint8(signature_result)
    verify = SR25519Lib.sr25519_verify(sig, msg, message.size, pk)
  end

  # Generate SR25519 keypair
  # @param seed [String] private key
  # @return [KeyPair] SR25519 keypair
  # @example
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   keypair = SR25519.keypair_from_seed(seed)
  def self.keypair_from_seed(seed)
    if seed.start_with?("0x")
      seed = seed.sub(/0x/, "")
    end
    seed_array = [seed].pack("H*").unpack("C*")
    seed = Seed.new
    seed[:String].to_ptr.write_array_of_uint8(seed_array)
    key_pair = KeyPair.new
    SR25519Lib.sr25519_keypair_from_seed(key_pair, seed)
    return key_pair
  end

  # Get SR25519 public key
  # @param seed [String] private key
  # @return [String] public key
  # @example
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   public_key = SR25519.get_public_key_from_seed(seed)
  def self.get_public_key_from_seed(seed)
    key_pair = self.keypair_from_seed(seed)
    key_pair.public_key
  end

  # Get SR25519 public key
  # @param address [String] account address
  # @param addr_type [Interger] address type
  # @return [String] public key
  # @example
  #   seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
  #   public_key = SR25519.get_public_key_from_seed(seed)
  #   address = Address.encode(public_key.to_s)
  #   public_key = SR25519.decode_address(address)
  def self.decode_address(address,addr_type=42)
    public_address = Address.decode(address,addr_type)
  end
end