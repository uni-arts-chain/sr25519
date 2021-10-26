
# The MIT License (MIT)

# Copyright (c) 2019 Wu Minzhe

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'base58'
require 'blake2b'

# The code is copy from https://github.com/itering/scale.rb/blob/develop/lib/common.rb
class Address
    SS58_PREFIX = 'SS58PRE'
  
    TYPES = [
      # Polkadot Live (SS58, AccountId)
      0, 1,
      # Polkadot Canary (SS58, AccountId)
      2, 3,
      # Kulupu (SS58, Reserved)
      16, 17,
      # Darwinia Live
      18,
      # Dothereum (SS58, AccountId)
      20, 21, 
      # Generic Substrate wildcard (SS58, AccountId)
      42, 43,
  
      # Schnorr/Ristretto 25519 ("S/R 25519") key
      48,
      # Edwards Ed25519 key
      49,
      # ECDSA SECP256k1 key
      50,
  
      # Reserved for future address format extensions.
      *64..255
    ]
  
    class << self
  
      def array_to_hex_string(arr)
        body = arr.map { |i| i.to_s(16).rjust(2, '0') }.join
        "0x#{body}"
      end
  
      def decode(address, addr_type = 42, ignore_checksum = true)
        decoded = Base58.base58_to_binary(address, :bitcoin)
        is_pubkey = decoded.size == 35
  
        size = decoded.size - ( is_pubkey ? 2 : 1 )
  
        prefix = decoded[0, 1].unpack("C*").first
  
        raise "Invalid address type" unless TYPES.include?(addr_type)
        
        hash_bytes = make_hash(decoded[0, size])
        if is_pubkey
          is_valid_checksum = decoded[-2].unpack("C*").first == hash_bytes[0] && decoded[-1].unpack("C*").first == hash_bytes[1]
        else
          is_valid_checksum = decoded[-1].unpack("C*").first == hash_bytes[0]
        end
  
        raise "Invalid decoded address checksum" unless is_valid_checksum && ignore_checksum
  
        decoded[1...size].unpack("H*").first
      end
  
  
      def encode(pubkey, addr_type = 42)
        pubkey = pubkey[2..-1] if pubkey =~ /^0x/i
        key = [pubkey].pack("H*")
  
        u8_array = key.bytes
  
        u8_array.unshift(addr_type)
  
        bytes = make_hash(u8_array.pack("C*"))
        
        checksum = bytes[0, key.size == 32 ? 2 : 1]
  
        u8_array.push(*checksum)
  
        input = u8_array.pack("C*")
  
        Base58.binary_to_base58(input, :bitcoin)
      end
  
      def make_hash(body)
        Blake2b.bytes("#{SS58_PREFIX}#{body}", Blake2b::Key.none, 64)
      end
  
    end
end