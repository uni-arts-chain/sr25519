# frozen_string_literal: true

RSpec.describe ED25519 do

  it "get keypair" do
    seed = "fac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
    expect(ED25519.keypair_from_seed(seed).keypair.size).to eq(64)
  end

  it "get keypair which start with 0x" do
    seed = "0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e"
    expect(ED25519.keypair_from_seed(seed).keypair.size).to eq(64)
  end

  it "get public key" do
    alice_key = "e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    expect(ED25519.get_public_key_from_seed(alice_key)).to eq("34602b88f60513f1c805d87ef52896934baf6a662bc37414dbdbf69356b1a691")
  end

  it "sign messsage" do
    alice_key = "e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    keypair = ED25519.keypair_from_seed(alice_key)
    message = "Hello world"
    signature_result = ED25519.sign(message, keypair)

    expect(signature_result).to eq("0x388c4757fc4df664abd492fbfd6948e5011d075f70a311b5ea043fc57be0f4eb8113d5a291bc9c8256501c8091793ea174c2830404ddc392846c7e5f45d14703")
  end

  it "verify messsage" do
    public_key = "34602b88f60513f1c805d87ef52896934baf6a662bc37414dbdbf69356b1a691"
    address = Address.encode(public_key)
    message = "Hello world"
    signature_result = "0x388c4757fc4df664abd492fbfd6948e5011d075f70a311b5ea043fc57be0f4eb8113d5a291bc9c8256501c8091793ea174c2830404ddc392846c7e5f45d14703"
    verify_result = ED25519.verify(address, message, signature_result)

    expect(verify_result).to eq(true)
  end
end
