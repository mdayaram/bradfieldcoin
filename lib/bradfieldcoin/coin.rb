module BradfieldCoin
  class Coin
    attr_reader :blockchain
    attr_reader :private_key
    attr_reader :public_key

    def initialize(starting_amount)
      @private_key, @public_key = PKI.generate_key_pair
      @blockchain = Blockchain::Blockchain.new(genesis_txn(starting_amount))
    end

    def valid_chain?
      blockchain.valid? && valid_transactions?
    end

    def transfer(to:, amount:)
      return false if amount <= 0
      return false if get_balances[public_key] < amount

      txn = Transaction.new(
        from: public_key,
        to: to,
        amount: amount,
        private_key: private_key
      )

      blockchain.add_block(txn)
      true
    end

    private

    def valid_transactions?
      balances = Hash.new(0)

      blockchain.blocks.each do |b|
        txn = b.content
        return false if txn.amount <= 0

        balances[txn.from] -= txn.amount if !txn.from.nil?
        balances[txn.to] += txn.amount

        # If at _any_ point in time amounts were negative, we have a problem.
        return false if balances[txn.from] < 0
        return false if balances[txn.to] < 0
      end

      true
    end

    def get_balances
      balance = Hash.new(0)
      blockchain.blocks.map(&:content).each do |txn|
        balance[txn.from] -= txn.amount if !txn.from.nil?
        balance[txn.to] += txn.amount
      end
      balance
    end

    def genesis_txn(amount)
      Transaction.new(
        from: nil,
        to: public_key,
        amount: amount,
        private_key: private_key
      )
    end
  end
end
