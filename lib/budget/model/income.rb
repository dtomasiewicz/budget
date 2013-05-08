module Budget

  class Income < Sequel::Model

    include CurrencyField

  end

end