# BradfieldCoin

It's time now to build our first cryptocurrency!

Naturally this is going to be a toy cryptocurrency and we're going to be cutting some corners. But our goal is to have a network of full nodes that are achieving consensus on the same blockchain.

Here are the recommended steps:

1. First, build out your blockchain from the blockchain assignment.
2. You'll want to adapt this blockchain to store transactions rather than random strings. I recommend creating a `Transaction` class, which includes a `from` (public key), `to` (public key), `amount` (int), and `signature` (string). Have each block contain one transaction for simplicity.
3. Make your blockchain validate that all of the transactions within the blockchain are valid—i.e., each transaction does not put any party into a negative balance. You'll want to start all blockchains with a genesis block that gives someone seed money to begin the chain.
4. Implement a fork choice rule. Given your current blockchain and a new blockchain, write a function that replaces the old blockchain with a new blockchain if it's longer than your current blockchain (and valid!)
5. Go back to your gossip protocol and adapt it to gossip blockchains rather than random messages. You may want to use a good marshalling library for your language to make it easier to serialize and deserialize your objects. Apply the fork choice rule to any message you receive.
6. Give each node a public key and private key. Give it an endpoint so that another node can query it for its public key.
7. Give each node a `transfer` endpoint, which will make it query another node for its public key, and then transfer that node some of its money.
8. See the blockchain in action!

That said, feel free to approach this in whatever way you feel makes the most sense.

Bonus: Implement races, have a node create a fork and try to see who ends up winning.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bradfieldcoin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bradfieldcoin

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bradfieldcoin.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
