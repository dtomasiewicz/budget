module Budget
  module Action

    def action_income
      redispatch(summary: "Show a chronological summary of all incomes",
                 new: "Add a new income")
    end
    def action_i; switch :action_income; end

    def action_income_summary
      opts

      month = nil
      fmt = "%-14s%-68s"
      Incomes.order('time DESC').each do |i|
        imonth = Time.at(i.time).localtime.strftime '%Y-%m'
        if month != imonth
          month = imonth
          puts "== #{month} =========="
          puts fmt % %w{Amount Note}
        end
        puts fmt % ["#{i.balance} #{i[:currency]}", i.note]
      end
    end

    def action_income_new
      amount, currency, note = opts %w{amount currency}, %w{note}

      puts "TODO"
    end
    def action_income_n; switch :action_income_new; end

  end
end