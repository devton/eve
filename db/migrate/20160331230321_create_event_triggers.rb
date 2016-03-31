class CreateEventTriggers < ActiveRecord::Migration
  def change
    create_table :event_triggers do |t|
      t.text :trigger_name
      t.text :description
      t.boolean :enabled

      t.timestamps null: false
    end
  end
end
