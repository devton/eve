# MailMessage handles with a email messages
# that can be delivered via events
class MailMessage < ActiveRecord::Base
  validates :label, uniqueness: true
  validates :label, :subject, :body, presence: true
end
