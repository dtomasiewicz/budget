module Budget

  # there is probably a better word for this
  class Delta < Sequel::Model

    include CurrencyField

  end

  Incomes = Delta.where 'balance >= 0'
  Expenses = Delta.where 'balance < 0'

end