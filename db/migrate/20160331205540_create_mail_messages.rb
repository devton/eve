class CreateMailMessages < ActiveRecord::Migration
  def change
    create_table :mail_messages do |t|
      t.text :label, null: false, index: :unique
      t.text :subject, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
