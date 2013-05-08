Sequel.migration do

  up do
    drop_table :expenses
    add_column :incomes, :note, String

    # can store a negative amount now (indicating expense)
    rename_column :incomes, :amount, :balance

    # make time nullable (for recurring/future incomes)
    drop_column :incomes, :time
    add_column :incomes, :time, Integer
  end

  down do
    drop_column :incomes, :time
    add_column :incomes, :time, null: false
    rename_column :incomes, :balance, :amount
    drop_column :incomes, :note

    create_table :expenses do
      primary_key :id, auto_increment: true
      Integer :time, null: false
      String :currency, null: false, size: 3
      Integer :amount, null: false
    end
  end
  
end