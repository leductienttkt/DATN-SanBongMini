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
      User.create!(
        name: "Lê Quang Cảnh",
        email: "ttkt1994@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "01234200394"
      )

      User.create!(
        name: "Cáp Kim Thảo",
        email: "ckt@love.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "0969861462"
      )

      User.create!(
        name: "Lê Đức Phụng",
        email: "ldp@love.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "01648163168"
      )

      User.create!(
        name: "Trần Văn Phú",
        email: "tvp@love.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "01666454958"
      )

      User.create!(
        name: "Cáp Văn Lợi",
        email: "cvl@love.com",
        password: "123456",
        password_confirmation: "123456",
        status: 1,
        phone: "0977476035"
      )
 
      10.times do |n|
        User.create!(
          name: Faker::Name.name,
          email: "nara-#{n+1}@love.com",
          password: "123456",
          password_confirmation: "123456",
          status: 1,
          phone: "098420039#{n}"
        )
      end

      puts "Create pitches and mini pitches"
      type = {1=>5, 2=>7, 3=>11} 

      Pitch.create!(
        name: "Mỹ Đình",
        description: "Sân bóng của LQC",
        status: 1,
        cover_image: "image",
        avatar: "image",
        owner_id: 2
      )

      Pitch.create!(
        name: "Chi Lăng",
        description: "Sân bóng của CKT",
        status: 1,
        cover_image: "image",
        avatar: "image",
        owner_id: 3
      )

      Pitch.create!(
        name: "Lạch Tray",
        description: "Sân bóng của LDP",
        status: 1,
        cover_image: "image",
        avatar: "image",
        owner_id: 4
      )

      Pitch.create!(
        name: "Hàng Đẫy",
        description: "Sân bóng của TVP",
        status: 1,
        cover_image: "image",
        avatar: "image",
        owner_id: 5
      )

      Pitch.create!(
        name: "Gò Đậu",
        description: "Sân bóng của CVL",
        status: 1,
        cover_image: "image",
        avatar: "image",
        owner_id: 6
      )

      mini_name = ["A","B","C","D","E"]
      Pitch.all.each do |pitch|
        mini_name.each do |t|
          MiniPitch.create!(
            name: "Sân #{t}",
            description: "#{pitch.name} - Sân #{t}",
            status: 0,
            image: "image",
            price: 10000,
            start_hour: "05:00:00",
            end_hour: "22:00:00",
            pitch_type: type[rand(1..3)],
            pitch_id: pitch.id,
            user_id: pitch.owner_id
          )
        end
      end
    end
  end
end
