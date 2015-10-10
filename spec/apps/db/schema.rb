# create tables
ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 0) do
  create_table :users, force: true do |t|
    t.string :name, :null => false
  end
end
