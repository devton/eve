class CreateSendgridEvents < ActiveRecord::Migration
  def change
    create_table :sendgrid_events do |t|
      t.references :event_executed_action, index: true, foreign_key: true
      t.text :event, null: false
      t.text :email, null: false
      t.text :useragent
      t.jsonb :data, default: '{}'

      t.timestamps null: false
    end
  end
end
