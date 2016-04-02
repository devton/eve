class MailActionCondition < ActiveRecord::Base
  belongs_to :event_trigger_mail_action

  validates :json_path, :cond_op, :match_value, presence: true
end
