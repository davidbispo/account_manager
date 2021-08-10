Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      Integer :balance, :null => false
    end
  end
end