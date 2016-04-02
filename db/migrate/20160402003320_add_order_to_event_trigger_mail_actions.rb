class AddOrderToEventTriggerMailActions < ActiveRecord::Migration
  def change
    add_column :event_trigger_mail_actions, :step, :integer, default: 0, index: { name: 'step_event_trg_mail_actions_idx', unique: true , with: [:event_trigger_id, :step] }
  end
end
