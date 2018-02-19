module BradfieldCoin
  class Transaction
    attr_reader :from
    attr_reader :to
    attr_reader :amount
    attr_reader :signature

    def initialize(from:, to:, amount:, signature: nil, private_key: nil)
      @from = from
      @to = to
      @amount = amount
      @signature = signature

      @signature = sign(private_key) if signature.nil?
    end

    def verified?
      return false if signature.nil?
      PKI.valid_signature?(message: message, signature: signature, public_key: from)
    end

    def to_json
      {
        from: from.to_s,
        to: to.to_s,
        amount: amount.to_i,
        signature: signature
      }
    end

    def to_s
      [
        "From: #{from}",
       "To: #{to}",
       "Amount: #{amount}",
       "Signature: #{signature}"
      ].join("\n")
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
