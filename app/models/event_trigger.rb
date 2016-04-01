# EventTrigger works like a dispatcher for with incoming events
class EventTrigger < ActiveRecord::Base
  has_many :mail_actions, class_name: 'EventTriggerMailAction'

  validates :trigger_name, :description, presence: true
  validates :trigger_name, uniqueness: true, format: { with: /\A[a-z\_0-9]+\z/ }

  accepts_nested_attributes_for :mail_actions, allow_destroy: true

  def to_s
    trigger_name
  end
end
