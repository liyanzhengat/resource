class CreateSlotNumbers < ActiveRecord::Migration
  def change
    create_table :slot_numbers do |t|
      t.integer :position
      t.string :name

      t.timestamps null: false
    end
  end
end
