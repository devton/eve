class ChangeMetadataDefault < ActiveRecord::Migration
  def up
    change_column_default :events, :metadata, '{}'
    change_column_default :event_executed_actions, :metadata, '{"cond_ok": true}'
  end

  def down
  end
end
