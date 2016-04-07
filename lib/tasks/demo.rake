namespace :demo do
  desc 'create demo user demo@demo.com/demo123'
  task demo_user: :environment do
    puts 'creating demo@demo.com with password demo1234'
    User.create!(email: 'demo@demo.com', password: 'demo1234', password_confirmation: 'demo1234')
    puts 'created'
  end

  desc 'Insert dummy data into database'
  task dummy_data: :environment do
    ActionMailer::Base.delivery_method = :test

    if MailMessage.count <= 0
      34.times do |i|
        puts "creating mail message in loop #{i}"
        MailMessage.create(
          label: "d_label_#{i}",
          subject: "dummy subject #{i} {{user.name}}",
          body: 'Hello {{user.name}} o/',
          created_at: (72 - i).hours.ago
        )
      end
    end
    if EventTrigger.count <= 0
      30.times do |i|
        puts "creating event trigger in loop #{i}"
        et = EventTrigger.create(
          trigger_name: "d_tr_name_#{i}",
          description: "tr_#{i} description",
          created_at: (72 - i).hours.ago
        )

        next if et.mail_actions.present?

        et.mail_actions.create(
          mail_message_id: MailMessage.order('random()').first.id,
          created_at: (72 - i).hours.ago
        )
      end
    end

    #Parallel.map(0..1000, in_processes: 4) do |i|
    500.times do |i| 
      puts "creating event in loop #{i}"
      #ActiveRecord::Base.connection_pool.with_connection do
        et = EventTrigger.order('random()').first
        event = Event.create(
          event_trigger: et,
          trigger_name: et.trigger_name,
          to: "some#{i}@email.com",
          subject_data: { user: { name: "Name #{i}" } },
          body_data: { user: { name: "Name #{i}" } },
          created_at: rand(0..72).days.ago
        )
        puts "created event #{event.id}"
        EventsProcessJob.perform_now(event.id)
      #end
    end
  end

end
