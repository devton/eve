class MailActionNotifier < ApplicationMailer
  def deliver(event_action, mail_action)
    event = event_action.event
    message = mail_action.mail_message
    message.parse(event.metadata.deep_symbolize_keys)
    configure_xsmtp_headers_for(event_action)

    mail(
      to: event.to,
      from: event.from,
      reply_to: event.reply_to,
      subject: message.parsed_subject,
      body: message.parsed_body
    )
  end

  def configure_xsmtp_headers_for(action)
    headers['X-SMTPAPI'] = {
      unique_args: { event_executed_action_id: action.id }
    }.to_json
  end
end
