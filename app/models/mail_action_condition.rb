# Handles with custom conditions for execute some action
# these conditions can be used to match metadata with some value
class MailActionCondition < ActiveRecord::Base
  # TODO: still missing implementation for 'in' and 'not_in'
  VALID_CONDS = %w(
    eq not_eq gt_that gt_or_eq_that
    lt_that lt_or_eq_that in not_in ).freeze

  belongs_to :event_trigger_mail_action

  validates :json_path, :cond_op, :match_value, presence: true
  validates :cond_op, inclusion: { in: VALID_CONDS }

  # Use json path over hash struct and
  # match condition value with result path
  def data_satisfy?(data = {})
    jdata = JsonPath.new(['$.', json_path].join).first(data.to_json)
    return false unless jdata.present?
    mapped_conditions[cond_op.to_sym].call(jdata)
  end

  private

  # TODO: maybe change..
  def mapped_conditions
    @mapped_conditions ||= {
      eq: -> (x) { cast_match_value_for(x) == x },
      not_eq: -> (x) { cast_match_value_for(x) != x },
      gt_that: -> (x) { cast_match_value_for(x) > x },
      gt_or_eq_that: -> (x) { cast_match_value_for(x) >= x },
      lt_that: -> (x) { cast_match_value_for(x) < x },
      lt_or_eq_that: -> (x) { cast_match_value_for(x) <= x }
    }
  end

  def cast_match_value_for(x)
    return match_value.to_i if x.is_a?(Fixnum)
    return match_value.to_f if x.is_a?(Float)
    return match_value.to_s if x.is_a?(String)
    match_value
  end
end
