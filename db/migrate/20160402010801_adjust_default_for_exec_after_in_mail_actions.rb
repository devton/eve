class AdjustDefaultForExecAfterInMailActions < ActiveRecord::Migration
  def change
    remove_column :event_trigger_mail_actions, :exec_after
    add_column :event_trigger_mail_actions, :exec_after, :integer, default: 0, null: false
  end
end
