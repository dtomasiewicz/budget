module Budget
  module Action

    def self.included(base)
    end

    def action_income
      dispatch
    end
    def action_i; switch :action_income; end

    def action_income_summary
      opts

      month = nil
      fmt = "%-10s%-68s"
      Incomes.order('time DESC').each do |i|
        imonth = Time.at(i.time).localtime.strftime '%Y-%m'
        if month != imonth
          month = imonth
          puts "== #{month} =========="
          puts fmt % %w{Amount Note}
        end
        puts fmt % [i.balance, i.note]
      end
    end

    def action_income_new
      opts
      
      puts "TODO"
    end
    def action_income_n; switch :action_income_new; end

  end
end