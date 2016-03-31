class CreateEventTriggerMailActions < ActiveRecord::Migration
  def change
    create_table :event_trigger_mail_actions do |t|
      t.references :event_trigger, index: true, foreign_key: true, null: false
      t.references :mail_message, index: true, foreign_key: true, null: false
      t.time :exec_after

      t.timestamps null: false
    end
  end
end
