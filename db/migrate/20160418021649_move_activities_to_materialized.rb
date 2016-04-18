class MoveActivitiesToMaterialized < ActiveRecord::Migration
  def up
    execute %Q{
drop view public.event_trigger_catalog_activities;
create materialized view public.event_trigger_catalog_activities as
select
    baseline.id as event_trigger_id,
    json_agg(
        json_build_object(
            'key', baseline.event,
            'values', baseline.data
        )
    ) as data
from (
with generated_time_series as (
    select s from generate_series((current_timestamp - '18 hours'::interval), now(), '10 minutes'::interval) as s
), total_events as (
    select event from sendgrid_events group by event
)
select
    et.id,
    te.event,
    json_agg(ARRAY[EXTRACT(EPOCH FROM gts.s), lt.total] order by EXTRACT(EPOCH FROM gts.s) asc)::jsonb as data
from generated_time_series gts, 
     total_events te,
     event_triggers et
     left join lateral (
        select count(1) as total
        from sendgrid_events sde
        join event_executed_actions exa on exa.id = sde.event_executed_action_id
        join events ev on ev.id = exa.event_id
        where sde.event = te.event and sde.created_at between gts.s and gts.s + '599 seconds'::interval
        and ev.event_trigger_id = et.id and sde.created_at > current_timestamp - '18 hours'::interval
     ) as lt on true
group by et.id, te.event
UNION
select 
    et.id,
    'new_events' as event,
    json_agg(ARRAY[EXTRACT(EPOCH FROM gts.s), lt.total] order by EXTRACT(EPOCH FROM gts.s) asc)::jsonb as data
from generated_time_series gts, 
     event_triggers et
     left join lateral (
        select count(1) as total
        from events ev
        where ev.created_at between gts.s and gts.s + '599 seconds'::interval
        and ev.event_trigger_id = et.id and ev.created_at > current_timestamp - '18 hours'::interval
     ) as lt on true
group by et.id
) as baseline
group by baseline.id;

create unique index event_trigger_id_idx on public.event_trigger_catalog_activities(event_trigger_id);
    }
  end

  def down
    execute %Q{
drop materialized view public.event_trigger_catalog_activities;
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
    }
  end
end
