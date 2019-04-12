User.create!(name:  "管理者",
             email: "yamamoto@gmail.com",
             password:              "yamamoto",
             password_confirmation: "yamamoto",
             admin: true)

59.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end