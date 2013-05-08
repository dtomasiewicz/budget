module Budget
  class Manager

    @cmd.command :account, 'Manage accounts', :a do |account|

      account.action :summary, 'Show a summary of all accounts', :s do
        Account.each do |acc|
          puts acc.info
        end
      end

      account.command :new, 'Create a new account', :n do |new|
        new.opts %w{account_name currency}, %w{note}
        new.exec do |name, currency, note|
          puts Account.create({
            name: name,
            currency: Currency.const_get(currency.to_sym),
            note: note
          }).info
        end
      end

      account.command :correct, "Correct an account's balance", :c do |correct|
        correct.opts %w{account_name new_balance}
        correct.exec do |name, new_balance|
          if acc = Account.first(name: name)
            amt = acc.curr_parse(new_balance) - acc.balance
            acc.add_transaction amount: amt, note: 'balance correction', time: Time.now.to_i
            puts acc.info
          else
            raise "invalid account: #{name}"
          end
        end
      end

      account.command :history, 'View the transaction history for an account', :h do |history|
        history.opts %w{account_name}
        history.exec do |name|
          if acc = Account.first(name: name)
            fmt = "%-10s%-21s%-37s%-10s"
            puts fmt % %w{Amount Time Note Balance}
            bal = acc.balance
            acc.transactions_dataset.order(:time).reverse_each do |t|
              amount_fmt = t.account.curr_format t.amount
              time_fmt = Time.at(t.time).localtime.strftime '%Y-%m-%d %H:%M:%S'
              bal_fmt = t.account.curr_format bal
              puts fmt % [amount_fmt, time_fmt, (t.note || ""), bal_fmt]
              bal -= t.amount
            end
          else
            raise "invalid account: #{name}"
          end
        end
      end

      account.command :transfer, 'Transfer money between two accounts', :t do |transfer|
        transfer.opts %w{from_account to_account amount}, %w{exchanged}
        transfer.exec do |fname, tname, amount, exchanged|
          from = Account.first name: fname
          to = Account.first name: tname
          if from && to
            amount = from.curr_parse amount
            xnote = ''
            if from.currency != to.currency
              if exchanged
                exchanged = to.curr_parse exchanged
                xnote = " (#{from[:currency]} #{from.curr_format amount})"
              else
                raise "account currencies differ; must provide exchanged amount"
              end
            else
              exchanged = amount
            end
            time = Time.now.to_i
            from.add_transaction amount: -amount, note: "transfer to #{tname}", time: time
            to.add_transaction amount: exchanged, note: "transfer from #{fname}#{xnote}", time: time
            puts from.info
            puts to.info
          else
            raise "invalid account: #{!from ? fname : tname}"
          end
        end
      end

    end

  end
end