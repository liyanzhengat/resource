class CreateProductCategorySpecSizes < ActiveRecord::Migration
  def change
    create_table :product_category_spec_sizes do |t|
      t.integer :product_category_id
      t.integer :position
      t.integer :spec_size_id

      t.timestamps null: false
    end
  end
end
