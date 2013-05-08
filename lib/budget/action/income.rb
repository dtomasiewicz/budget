module Budget
  class Manager

    @cmd.command :income, 'Manage incomes', :i do |income|

      income.action :summary, 'Show a chronological summary of all incomes' do
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

      income.command :new, 'Add a new income', :n do |new|
        new.opts %w{amount currency}, %w{note}
        new.exec do |amount, currency, note|
          puts "TODO"
        end
      end

    end

  end
end