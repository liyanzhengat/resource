class CreateProductStructures < ActiveRecord::Migration
  def change
    create_table :product_structures do |t|
      t.integer :position
      t.string :name
      t.string :en_name

      t.timestamps null: false
    end
  end
end
