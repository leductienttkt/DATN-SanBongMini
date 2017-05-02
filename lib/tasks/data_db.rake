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

      User.create!(
        name: "Guest",
        email: "guest@love.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "01234200394"
      )
 
      puts "Create users"
      (2..9).each do |n|
        User.create!(
          name: "Nara",
          email: "nara-#{n}@love.com",
          password: "123456",
          password_confirmation: "123456",
          status: 1,
          phone: "0123420039#{n}"
        )
      end

      puts "Create pitches and mini pitches"
      type = {1=>5, 2=>7, 3=>11} 
      (2..9).each do |n|
        pitch = Pitch.create!(
          name: "Pitch #{n}",
          description: "Pitch #{n}",
          status: 0,
          cover_image: "image",
          avatar: "image",
          owner_id: n-1
        )

        (2..6).each do |t|
          MiniPitch.create!(
            name: "Pitch #{n-1} - mini #{t}",
            description: "Pitch #{n-1} - mini #{t}",
            status: 0,
            image: "image",
            price: 10000,
            start_hour: "05:00:00",
            end_hour: "22:00:00",
            pitch_type: type[rand(1..3) ],
            pitch_id: n-1,
            user_id: n-1
          )
        end
      end
    end
  end
end