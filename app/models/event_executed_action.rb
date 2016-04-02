class EventExecutedAction < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_trigger_mail_action

  validates :event, :event_trigger_mail_action, presence: true
end
