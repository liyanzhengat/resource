class CreateSpecSizes < ActiveRecord::Migration
  def change
    create_table :spec_sizes do |t|
      t.integer  "position"
      t.string   "name"
      t.timestamps null: false
    end
  end
end
