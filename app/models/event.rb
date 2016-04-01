class Event < ActiveRecord::Base
  belongs_to :event_trigger
  has_many :executed_actions, class_name: 'EventExecutedAction'

  serialize :metadata, HashSerializer
  store_accessor :metadata, :to, :from, :reply_to

  validates :event_trigger, :metadata, presence: true
  validate :validate_metadata_format, if: -> (x) { x.metadata.present? }

  # Event metadata schema
  def self.metadata_schema
    {
      type: 'object',
      required: %i(event_trigger to),
      properties: {
        event_trigger: { type: 'string' },
        from: { type: 'string' },
        to: { type: 'string' },
        reply_to: { type: 'string' },
        subject_data: { type: 'object' },
        body_data: { type: 'object' }
      }
    }
  end

  private

  def validate_metadata_format
    schema_errors = JSON::Validator.fully_validate(
      Event.metadata_schema, metadata)

    if schema_errors.present?
      errors.add(:metadata, parse_schema_errors(schema_errors))
    end
  end

  def parse_schema_errors(errs)
    errs.collect do |e|
      "missing required attribute on metadata #{e.match(/property of \'(.*)\'/)[1]}"
    end.compact.to_sentence
  end
end
