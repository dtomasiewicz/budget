Sequel.migration do
  change do
    create_table :month_balances do
      foreign_key :account_id, :accounts, null: false
      Integer :month, null: false
      Integer :balance, null: false
      primary_key [:account_id, :month]
    end

    create_table :incomes do
      primary_key :id, auto_increment: true
      Integer :time, null: false
      String :currency, null: false, size: 3
      Integer :amount, null: false
    end

    create_table :expenses do
      primary_key :id, auto_increment: true
      Integer :time, null: false
      String :currency, null: false, size: 3
      Integer :amount, null: false
    end
  end
end