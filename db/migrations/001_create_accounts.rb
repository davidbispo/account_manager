Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      Float :balance, :null => false
    end
  end
end