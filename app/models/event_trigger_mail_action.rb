# EventTriggerMailAction is a mail message
# linked into event trigger
class EventTriggerMailAction < ActiveRecord::Base
  belongs_to :event_trigger
  belongs_to :mail_message

  validates :event_trigger, :mail_message, :step, presence: true
  validates :step, uniquness: { scope: %i( event_trigger_id ) }
  validates :exec_after, length: { minimum: 0 }

  scope :step_order, -> () { order(step: :asc) }
end
