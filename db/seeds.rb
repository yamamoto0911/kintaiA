User.create!(name:  "管理者",
             email: "admin@email.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)

User.create!(name:  "上長１",
             email: "superior1@email.com",
             password:              "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name:  "上長２",
             email: "superior2@email.com",
             password:              "password",
             password_confirmation: "password",
             superior: true)

User.create!(name:  "一般１",
             email: "user1@email.com",
             password:              "password",
             password_confirmation: "password")
             
User.create!(name:  "一般２",
             email: "user2@email.com",
             password:              "password",
             password_confirmation: "password")

Base.create!(name: "東京",
             number: 1,
             type: "営業" )

Base.create!(name: "大阪",
             number: 2,
             type: "営業" )
