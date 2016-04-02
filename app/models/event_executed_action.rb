class EventExecutedAction < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_trigger_mail_action

  serialize :metadata, HashSerializer
  store_accessor :metadata, :cond_ok, :cond

  validates :event, :event_trigger_mail_action, presence: true

  scope :only_ok, -> { where('metadata @> ?', {cond_ok: true}.to_json) }
end
