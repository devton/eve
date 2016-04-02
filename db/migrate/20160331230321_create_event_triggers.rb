class CreateEventTriggers < ActiveRecord::Migration
  def change
    create_table :event_triggers do |t|
      t.text :trigger_name, index: :unique, null: false
      t.text :description
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
  end
end
