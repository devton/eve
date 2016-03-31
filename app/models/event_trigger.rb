# EventTrigger works like a dispatcher for with incoming events
class EventTrigger < ActiveRecord::Base
  has_many :mail_actions, class_name: 'EventTriggerMailAction'

  validates :trigger_name, :description, presence: true
  validates :trigger_name, uniqueness: true, format: { with: /\A[a-z\_0-9]+\z/ }
end
