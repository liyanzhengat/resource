class CreateVoltageLevels < ActiveRecord::Migration
  def change
    create_table :voltage_levels do |t|
      t.integer :position
      t.string :name
      t.string :en_name

      t.timestamps null: false
    end
  end
end
