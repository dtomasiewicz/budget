module Budget

  class Account < Sequel::Model

    include CurrencyField
    
    one_to_many :transactions, class: 'Budget::Transaction'
    one_to_many :month_balances, class: 'Budget::MonthBalance'

    def info
      s = "#{name} (#{self[:currency]})\t\t#{curr_format balance}"
      note ? s+"\n  #{note}" : s
    end

    def balance
      transactions.map(&:amount).inject 0, :+
    end

  end

end