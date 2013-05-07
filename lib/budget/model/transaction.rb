module Budget

  class Transaction < Sequel::Model
    
    many_to_one :account, class: 'Budget::Account', reciprocal: :transactions

  end

end