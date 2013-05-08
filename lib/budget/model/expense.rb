module Budget

  class Expense < Sequel::Model

    include CurrencyField

  end

end