module Budget
  module CurrencyField

    def after_initialize
      extend currency
    end

    def currency
      Currency.const_get self[:currency].to_sym
    end

    def currency=(mod)
      raise "cannot change currency" if self[:currency]
      self[:currency] = mod.name.split('::').last
      extend currency
    end

  end
end