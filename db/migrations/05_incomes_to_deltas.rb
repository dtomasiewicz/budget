Sequel.migration do

  change do
    rename_table :incomes, :deltas
  end
  
end