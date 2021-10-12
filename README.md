# Sr25519

This is a ruby libraray for Sr25519. Use to sign and verify message.

More info at: https://github.com/w3f/schnorrkel

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sr25519'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sr25519

## Usage

#### 1. Require ed25519.rb in your Ruby program:
```ruby
require "sr25519"
```

#### 2. SR25519 Generate keypair

```ruby
# seed is priviate key, is a hex string.
# example: SR25519.keypair_from_seed("0xfac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e")
keypair = SR25519.keypair_from_seed(seed)

```

#### 3. SR25519 Generate public_key

```ruby
public_key = SR25519.get_public_key_from_seed(seed)

# get the hex string
public_key_str = public_key.to_s

```

#### 4. Encode address
```ruby
address = Address.encode(public_key.to_s)
```

#### 5. Decode address

```ruby
address = Address.decode(address)
```

#### 6. SR25519 Sign message

```ruby
signature_result = SR25519.sign(message, keypair)

```

#### 7. SR25519 Verify message

```ruby
SR25519.verify(address, message, signature_result)
```

#### 8.  ED25519 Generate keypair

```ruby
ED25519.keypair_from_seed(seed)
```

#### 9.  ED25519 Sign message

```ruby
ED25519.sign(message, keypair)
```

#### 10. ED25519 Verify message

```ruby
ED25519.verify(address, message, signature_result)
```


## Running tests
1. Run all tests

```ruby
rspec
```


## Docker

1. Update to latest image

   `docker pull uniart/sr25519:latest`

2. Run image:

   `docker run -it uniart/sr25519:latest bash`

   This  will enter the container with a linux shell opened. 

   ```shell
   /usr/src/app # 
   ```

3. Type `rspec` to run all tests

   ```shell
   /usr/src/app # rspec
   
   ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uni-arts-chain/sr25519. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/uni-arts-chain/sr25519/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
