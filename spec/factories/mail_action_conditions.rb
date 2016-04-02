FactoryGirl.define do
  factory :mail_action_condition do
    json_path 'subject_data.user.name'
    cond_op 'eq'
    match_value 'yoo'
    event_trigger_mail_action
  end
end
