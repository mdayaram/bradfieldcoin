require "blockchain"
require "gossip_server"

require "bradfieldcoin/version"
require "bradfieldcoin/pki"
require "bradfieldcoin/transaction"
require "bradfieldcoin/coin_state"
require "bradfieldcoin/server"

module BradfieldCoin
  def self.run!
    options = {
      starting_amount: 10_000,
      seed: nil,
      port: 8000,
      infection_factor: 2,
      default_ttl: 3,
      gossip_interval: 10,
    }

    OptionParser.new do |opts|
      opts.on(
        "-a", "--starting-amount N", Integer,
        "The amount of coins this server starts out with; " +
        "defaults to #{options[:starting_amount]}"
      ) { |v| options[:starting_amount] = v }

      opts.on(
        "-p", "--port N", Integer,
        "The port to listen gossip on; " +
        "defaults to #{options[:port]}"
      ) { |v| options[:port] = v }

      opts.on(
        "-s", "--seed N", Integer,
        "The seed port to fetch initial peers from; " +
        "defaults to no seeds"
      ) { |v| options[:seed] = v }

      opts.on(
        "--infection-factor N", Integer,
        "The number of nodes to gossip to when gossiping; " +
        "defaults to #{options[:infection_factor]}"
      ) { |v| options[:infection_factor] = v }

      opts.on(
        "--ttl N", Integer,
        "How many nodes messages will travel before being dropped; " +
        "defaults to #{options[:default_ttl]}"
      ) { |v| options[:default_ttl] = v }

      opts.on(
        "--gossip-interval N", Integer,
        "How often should the server gossip in integer seconds; " +
        "defaults to #{options[:gossip_interval]}"
      ) { |v| options[:gossip_interval] = v }
    end.parse!

    world_state = CoinState.new(options[:starting_amount])
    gossiper = GossipServer::Gossiper.new(
      id: options[:port].to_s,
      seed_id: options[:seed].to_s,
      infection_factor: options[:infection_factor].to_i,
      default_ttl: options[:default_ttl].to_i,
      world_state: world_state
    )
    # Start the gossiper with a single message of our genesis blockchain
    gossiper.add_payload(world_state.to_json)

    gossiper.fetch_peers!

    scheduler = GossipServer::Scheduler.new(
      gossiper: gossiper,
      gossip_interval: options[:gossip_interval]
    )
    scheduler.start!

    Server.set :chain_gossiper, gossiper
    Server.set :port, options[:port]
    Server.run!
  end
end
