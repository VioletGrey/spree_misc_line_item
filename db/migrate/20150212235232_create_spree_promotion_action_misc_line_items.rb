class CreateSpreePromotionActionMiscLineItems < ActiveRecord::Migration
  def change
    create_table :spree_promotion_action_misc_line_items do |t|
      t.references :promotion_action
      t.references :variant, index: true
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity
      t.string :name

      t.timestamps
    end

    add_index "spree_promotion_action_misc_line_items", ["promotion_action_id"], name: "index_spree_promo_misc_line_items_on_promo_id", using: :btree
  end
end
