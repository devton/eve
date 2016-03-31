# MailMessage handles with a email messages
# that can be delivered via events
class MailMessage < ActiveRecord::Base
  validates :label, uniqueness: true, format: { with: /\A[a-z\_0-9]+\z/ }
  validates :label, :subject, :body, presence: true

  attr_accessor :parsed_subject, :parsed_body

  # handles with template parse for message
  # attributes should be in format:
  # attrs = {
  #   subject_data: {
  #     'var1' => 'ipsum'
  #   },
  #   body_data: {
  #     'var1' => 'lorem'
  #   }
  # }
  def parse(attrs)
    parse_subject(attrs.delete(:subject_data))
    parse_body(attrs.delete(:body_data))
  end

  # parse subject_template with given attributes
  # rendered template are stored into parsed_subject
  def parse_subject(attrs = {})
    self.parsed_subject = subject_template.render(
      attrs.deep_stringify_keys, strict_variables: true)
  end

  # parse body_template with given attributes
  # rendered template are stored into parsed_body
  def parse_body(attrs = {})
    self.parsed_body = body_template.render(
      attrs.deep_stringify_keys, strict_variables: true)
  end

  # subject template over template parser
  def subject_template(parser = template_parser)
    @st ||= parser.parse(subject)
  end

  # body template over template parser
  def body_template(parser = template_parser)
    @bt ||= parser.parse(body)
  end


  def template_parser
    Liquid::Template
  end

end
