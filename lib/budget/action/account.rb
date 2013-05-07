module Budget

  module Action

    def action_account(*args)
      dispatch args, :account
    end
    alias_method :action_a, :action_account

    def action_account_summary
      Account.each do |acc|
        puts acc.info
      end
    end

    def action_account_new(name, currency, *note)
      note = note.length > 0 ? note.join(' ') : nil
      puts Account.create({
        name: name,
        currency: Currency.const_get(currency.to_sym),
        note: note
      }).info
    end
    alias_method :action_account_n, :action_account_new

    def action_account_correct(name, new_balance)
      if acc = Account.first(name: name)
        amt = acc.curr_parse(new_balance) - acc.balance
        acc.add_transaction amount: amt, note: 'balance correction', time: Time.now.to_i
        acc.balance += amt
        acc.save
        puts acc.info
      else
        raise "invalid account: #{name}"
      end
    end
    alias_method :action_account_c, :action_account_correct

    def action_account_transactions(name)
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
    alias_method :action_account_t, :action_account_transactions

  end

end