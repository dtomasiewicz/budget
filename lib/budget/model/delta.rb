module Budget

  # there is probably a better word for this
  class Delta < Sequel::Model

    include CurrencyField

  end

  Income = Delta.where 'balance >= 0'
  Expense = Delta.where 'balance < 0'

end