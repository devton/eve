# EventTriggerMailAction is a mail message
# linked into event trigger
class EventTriggerMailAction < ActiveRecord::Base
  belongs_to :event_trigger
  belongs_to :mail_message

  validates :event_trigger, :mail_message, presence: true
end
