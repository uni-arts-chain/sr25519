# frozen_string_literal: true

RSpec.describe Sr25519 do

  it "get keypair" do
    seed = "fac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
    expect(SR25519.keypair_from_seed(seed).to_s.size).to eq(96 * 2)
  end

  it "get keypair which start with 0x" do
    seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
    expect(SR25519.keypair_from_seed(seed).to_s.size).to eq(96 * 2)
  end

  it "get public key" do
    alice_key = "e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    expect(SR25519.get_public_key_from_seed(alice_key).to_s).to eq("d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d")
  end

  it "sign and verify messsage" do
    alice_key = "e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    public_key = SR25519.get_public_key_from_seed(alice_key).to_s
    keypair = SR25519.keypair_from_seed(alice_key)
    address = Address.encode(public_key)
    message = "Hello world"
    signature_result = SR25519.sign(message, keypair)

    expect(SR25519.verify(address, message, signature_result)).to eq(true)
  end

  it "verify wrong messsage" do
    alice_key = "e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    public_key = SR25519.get_public_key_from_seed(alice_key).to_s
    keypair = SR25519.keypair_from_seed(alice_key)
    address = Address.encode(public_key)
    message = "Hello world"
    signature_result = SR25519.sign(message, keypair)

    expect(SR25519.verify(address, message + "-test", signature_result)).to eq(false)
  end
end
