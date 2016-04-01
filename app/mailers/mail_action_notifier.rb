class MailActionNotifier < ApplicationMailer
  def deliver(event, mail_action)
    message = mail_action.mail_message
    message.parse(event.metadata.deep_symbolize_keys)

    mail(
      to: event.to,
      from: event.from,
      reply_to: event.reply_to,
      subject: message.parsed_subject,
      body: message.parsed_body
    )
  end
end
