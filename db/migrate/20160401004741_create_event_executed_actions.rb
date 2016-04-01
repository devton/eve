class CreateEventExecutedActions < ActiveRecord::Migration
  def change
    create_table :event_executed_actions do |t|
      t.references :event, index: true, foreign_key: true, null: false
      t.references :event_trigger_mail_action, index: true, foreign_key: true
      t.jsonb :metadata

      t.timestamps null: false
    end
  end
end
