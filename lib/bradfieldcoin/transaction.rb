module BradfieldCoin
  class Transaction
    attr_reader :from
    attr_reader :to
    attr_reader :amount
    attr_reader :signature

    def initialize(from:, to:, amount:, private_key: nil)
      @from = from
      @to = to
      @amount = amount
      @signature = sign(private_key)
    end

    def verified?
      return false if signature.nil?
      PKI.valid_signature?(message: message, signature: signature, public_key: from)
    end

    def ==(other)
      return false if other.nil? || !is_a?(Transaction)

      from == other.from &&
        to == other.to &&
        amount == other.amount &&
        signature == other.signature
    end

    def to_s
      [
        "From: #{from}",
       "To: #{to}",
       "Amount: #{amount}",
       "Signature: #{signature}"
      ].join("\n")
    end

    def to_json
      {
        from: from,
        to: to,
        amount: amount.to_i,
        signature: signature
      }
    end

    def self.from_json(json)
      txn = Transaction.allocate # creates instance without calling new/initialize
      txn.instance_variable_set(:@from, json[:from])
      txn.instance_variable_set(:@to, json[:to])
      txn.instance_variable_set(:@amount, json[:amount])
      txn.instance_variable_set(:@signature, json[:signature])
      txn
    end

    private

    def sign(private_key)
      raise "Need a private key to sign this transaction!" if private_key.nil?
      PKI.sign(message: message, private_key: private_key)
    end

    def message
      [from, to, amount].map(&:to_s).join
    end
  end
end
