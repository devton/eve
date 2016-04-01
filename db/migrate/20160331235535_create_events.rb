class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :event_trigger, index: true, foreign_key: true
      t.jsonb :metadata, null: false

      t.timestamps null: false
    end
  end
end
