module Budget

  class Account < Sequel::Model
    
    one_to_many :transactions, class: 'Budget::Transaction'

    def info
      s = "#{name} (#{self[:currency]})\t\t#{curr_format balance}"
      note ? s+"\n  #{note}" : s
    end

    def after_initialize
      extend currency
    end

    def currency
      Currency.const_get self[:currency].to_sym
    end

    def currency=(mod)
      self[:currency] = mod.name.split('::').last
      extend currency
    end

  end

end