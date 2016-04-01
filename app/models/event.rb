class Event < ActiveRecord::Base
  belongs_to :event_trigger

  validates :event_trigger, :metadata, presence: true
end
