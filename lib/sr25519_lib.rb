require 'ffi'
require 'address'
module SR25519Lib
  extend FFI::Library
 
  ffi_lib FFI::Library::LIBC

  # The library is compile from https://github.com/Warchant/sr25519-crust
  ffi_lib [File.expand_path('lib/libsr25519crust.so')] if RUBY_PLATFORM =~ /linux/
  ffi_lib [File.expand_path('lib/libsr25519crust.dylib')] if RUBY_PLATFORM =~ /darwin/

  attach_function :sr25519_keypair_from_seed, [:pointer, :pointer], :void
  attach_function :sr25519_verify, [:pointer, :pointer, :uint, :pointer], :bool
  attach_function :sr25519_sign, [:pointer, :pointer, :pointer, :pointer, :uint], :void

end

class KeyPair < FFI::Struct
  # [32b key | 32b nonce | 32b public]
  layout :String, [:uint8, 96]

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

  def to_s
    self[:String].to_a.pack("c*").unpack1("H*")
  end
end

class SR25519

  def self.sr25519_sign(message, private_key)
    sig = SigMessage.new
    msg = FFI::MemoryPointer.from_string(message)
    key_pair = self.sr25519_keypair_from_seed(private_key)
    public_key = key_pair.public_key
    SR25519Lib.sr25519_sign(sig, public_key, key_pair, msg, message.length)
    sig.to_s
  end


  # Creates a signature for given data
  def self.sign(message, key_pair)
    sig = SigMessage.new
    msg = FFI::MemoryPointer.from_string(message)
    public_key = key_pair.public_key
    SR25519Lib.sr25519_sign(sig, public_key, key_pair, msg, message.length)
    sig.to_s
  end

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

  def self.sr25519_keypair_from_seed(seed)
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

  def self.get_public_key_from_seed(seed)
    key_pair = self.sr25519_keypair_from_seed(seed)
    key_pair.public_key
  end

  def self.decode_address(address,addr_type=42)
    public_address = Address.decode(address,addr_type)
  end
end