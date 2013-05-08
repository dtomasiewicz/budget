module Budget

  module Action

    def action_account
      dispatch
    end
    def action_a; switch :action_account; end

    def action_account_summary
      opts

      Account.each do |acc|
        puts acc.info
      end
    end

    def action_account_new
      name, currency, note = opts %w{name currency}, %w{note}

      #note = note.length > 0 ? note.join(' ') : nil
      puts Account.create({
        name: name,
        currency: Currency.const_get(currency.to_sym),
        note: note
      }).info
    end
    def action_account_n; switch :action_account_new; end

    def action_account_correct
      name, new_balance = opts %w{account_name, new_balance}

      if acc = Account.first(name: name)
        amt = acc.curr_parse(new_balance) - acc.balance
        acc.add_transaction amount: amt, note: 'balance correction', time: Time.now.to_i
        puts acc.info
      else
        raise "invalid account: #{name}"
      end
    end
    def action_account_c; switch :action_account_correct; end

    def action_account_history
      name, *_ = opts %w{account_name}

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
    def action_account_h; switch :action_account_history; end

    def action_account_transfer
      fname, tname, amount, exchanged = opts %w{from_account to_account amount}, %w{exchanged}

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
    def action_account_t; switch :action_account_transfer; end

  end

end