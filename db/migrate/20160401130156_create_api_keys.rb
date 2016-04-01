class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.text :key, null: false, index: :unique
      t.text :public_key, null: false
      t.text :private_key, null: false
      t.boolean :enabled, default: true, null: false

      t.timestamps null: false
    end
  end
end
