class AddEventTriggerCatalogView < ActiveRecord::Migration
  def up
    execute <<-SQL
CREATE OR REPLACE VIEW public.event_trigger_catalog AS
select
    et.id as event_trigger_id,
    et.trigger_name,
    count(distinct e.id) as total_events,
    count(distinct sde.id) filter (where sde.event = 'delivered') as delivered_total,
    count(distinct sde.id) filter (where sde.event = 'open') as open_total,
    count(distinct sde.id) filter (where sde.event = 'spamreport') as spam_total,
    count(distinct sde.id) filter (where sde.event = 'click') as click_total,
    count(distinct sde.id) filter (where sde.event = 'dropped') as drop_total
from events e
join event_triggers et on et.id = e.event_trigger_id
left join event_executed_actions exa on exa.event_id = e.id
left join sendgrid_events sde on sde.event_executed_action_id = exa.id
group by et.id
order by total_events desc;

create or replace view public.event_trigger_catalog_activities as
with generated_time_series as (
    select s from generate_series((now() - '12 hours'::interval), now(), '30 minutes'::interval) as s
), total_events as (
    select event from sendgrid_events group by event
)
select
    baseline.id as event_trigger_id,
    json_agg(
        json_build_object(
            'key', baseline.event,
            'values', baseline.data
        )
    ) as data
from (
    select
        et.id,
        'new_events' as event,
        json_agg(ARRAY[EXTRACT(EPOCH FROM gts.s), lt.total])::jsonb as data
    from generated_time_series gts, 
         event_triggers et
         left join lateral (
            select count(1) as total
            from events ev
            where ev.created_at between gts.s and gts.s + '1799 seconds'::interval
            and ev.event_trigger_id = et.id
         ) as lt on true
    group by et.id
    
    UNION
    
    select
        et.id,
        te.event,
        json_agg(ARRAY[EXTRACT(EPOCH FROM gts.s), lt.total])::jsonb as data
    from generated_time_series gts, 
         total_events te,
         event_triggers et
         left join lateral (
            select count(1) as total
            from sendgrid_events sde
            join event_executed_actions exa on exa.id = sde.event_executed_action_id
            join events ev on ev.id = exa.event_id
            where sde.event = te.event and sde.created_at between gts.s and gts.s + '1799 seconds'::interval
            and ev.event_trigger_id = et.id
         ) as lt on true
    group by et.id, te.event
) as baseline
group by baseline.id;
    SQL

    add_index :sendgrid_events, :event
    add_index :sendgrid_events, :created_at
  end

  def down
    remove_index :sendgrid_events, :event
    remove_index :sendgrid_events, :created_at
    execute <<-SQL
DROP VIEW public.event_trigger_catalog;
DROP VIEW public.event_trigger_catalog_activities;
    SQL
  end
end
