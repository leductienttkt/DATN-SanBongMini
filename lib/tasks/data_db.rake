namespace :db do
  desc "Seeding data"
  task seeding: :environment do
    if Rails.env.production?
      puts "Do not running in 'Production' task"
    else
      %w[db:drop db:create db:migrate db:seed].each do |task|
        Rake::Task[task].invoke
      end

      puts "Create Admin"
      Admin.create!(
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: "123456")
 
      puts "Create users"
      10.times do |n|
        User.create!(
          name: "Nara",
          email: "nara-#{n+1}@love.com",
          password: "123456",
          password_confirmation: "123456",
          status: 1,
          phone: "01234200394"
        )
      end

      puts "Create pitches and mini pitches"
      type = {1=>5, 2=>7} 
      10.times do |n|
        pitch = Pitch.create!(
          name: "Pitch #{n+1}",
          description: "Pitch #{n+1}",
          status: 0,
          cover_image: "image",
          avatar: "image",
          owner_id: n + 1
        )

        5.times do |t|
          MiniPitch.create!(
            name: "Pitch #{n} - mini #{t+1}",
            description: "Pitch #{n} - mini #{t+1}",
            status: 0,
            image: "image",
            price: 10000,
            start_hour: "05:00:00",
            end_hour: "22:00:00",
            pitch_type: type[rand(1..2) ],
            pitch_id: n+1,
            user_id: n+1
          )
        end
      end

      puts "Create rents"
      10.times do |t|
        Rent.create!(
          start_hour: "07:00:00",
          end_hour: "10:00:00",
          date: "25-04-2017",
          user_id: t+1,
          mini_pitch_id: t+1
        )
      end
    end
  end
end