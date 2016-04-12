# this is an VIEW to aggregate event_trigger events data
class EventTriggerCatalog < ActiveRecord::Base
  paginates_per 5
  max_paginates_per 10
  self.table_name = 'event_trigger_catalog'

  def last_activity
    @last_activity ||= EventTriggerCatalogActivity.find_by_event_trigger_id event_trigger_id
  end
end
