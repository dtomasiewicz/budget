Sequel.migration do
  change do
    create_table :settings do
      primary_key :key, :string, auto_increment: false, null: false
      String :value
    end

    create_table :accounts do
      primary_key :id, auto_increment: true
      String :name, null: false, size: 10
      String :currency, null: false, size: 3
      Integer :balance, null: false, default: 0
      String :note
      index :name, unique: true
    end

    create_table :transactions do
      primary_key :id, auto_increment: true
      foreign_key :account_id, :accounts, null: false
      Integer :amount, null: false
      Integer :time, null: false
      String :note
    end
  end
end