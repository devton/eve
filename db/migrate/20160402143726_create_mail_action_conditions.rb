class CreateMailActionConditions < ActiveRecord::Migration
  def change
    create_table :mail_action_conditions do |t|
      t.text :json_path, null: false
      t.text :cond_op, null: false
      t.text :match_value, null: false
      t.references :event_trigger_mail_action, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
