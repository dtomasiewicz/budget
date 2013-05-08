module Budget

  class MonthBalance < Sequel::Model
    
    many_to_one :account, class: 'Budget::Account', reciprocal: :month_balances

  end

end