# Sr25519

This is a ruby libraray for Sr25519.

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

1.  keypair

```ruby
# seed is priviate key, is a hex string.
keypaire = SR25519.sr25519_keypair_from_seed(seed)

```

2. public_key

```ruby
public_key = SR25519.get_public_key_from_seed(seed)

# get the hex string
public_key_str = public_key.to_s

```

3. encode address
```ruby
address = Address.encode(public_key.to_s)
```

4. decode address

```ruby
address = Address.decode(address)
```

5. sign

```ruby
signature_result = SR25519.sign(message, keypair)

```

6. verify

```ruby
SR25519.verify(address, message, signature_result)
```

## Running tests
1. Run all tests

```ruby
rspec
```


## Docker

1. update to latest image

   `docker pull uniart/sr25519:latest`

2. Run image:

   `docker run -it uniart/sr25519:latest`

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
