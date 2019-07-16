User.create!(name:  "管理者",
             email: "yamamoto@gmail.com",
             password:              "yamamoto",
             password_confirmation: "yamamoto",
             admin: true)

User.create!(name:  "上司１",
             email: "yamamoto1@gmail.com",
             password:              "yamamoto",
             password_confirmation: "yamamoto",
             superior: true)
             
User.create!(name:  "上司２",
             email: "yamamoto2@gmail.com",
             password:              "yamamoto",
             password_confirmation: "yamamoto",
             superior: true)
             

4.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

Base.create!(name: "東京",
             number: 1,
             type: "営業" )

Base.create!(name: "大阪",
             number: 2,
             type: "営業" )
