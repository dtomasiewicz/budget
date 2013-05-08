Sequel.migration do
  up do
    drop_column :accounts, :balance
  end

  down do
    add_column :accounts, :balance, Integer, null: false, default: 0
  end
end