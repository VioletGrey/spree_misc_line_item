class CreateSpreeMiscLineItems < ActiveRecord::Migration
  def change
    create_table :spree_misc_line_items do |t|
      t.references :order, index: true
      t.integer :quantity, null: false, default: 0
      t.decimal :price, precision: 8, scale: 2, null: false
      t.decimal :variant_price, precision: 8, scale: 2, null: false
      t.decimal :cost_price, precision: 8, scale: 2, null: false
      t.string :currency
      t.references :tax_category, index: true
      t.boolean :eligible, null: false, default: false
      t.boolean :promotion, null: false, default: false
      t.text :description
      t.string :name
      t.references :lineitemeable, polymorphic: true

      t.timestamps
    end

    add_index "spree_misc_line_items", ["lineitemeable_id", "lineitemeable_type"], name: "index_spree_misc_line_items_on_lineitemeable", using: :btree
  end
end
