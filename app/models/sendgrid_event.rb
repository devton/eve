class SendgridEvent < ActiveRecord::Base
  belongs_to :event_executed_action
  validates :event_executed_action, :email, :event, presence: true
end
