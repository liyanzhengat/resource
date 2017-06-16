class CreateWaterTemperatures < ActiveRecord::Migration
  def change
    create_table :water_temperatures do |t|
      t.integer :position
      t.string :name
      t.string :en_name

      t.timestamps null: false
    end
  end
end
