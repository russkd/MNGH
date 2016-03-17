User.create!(name: "Russ Dollinger",
            email: "russ.dollinger@ingenuitor.com",
            password: "password",
            password_confirmation: "password",
            admin: true)

User.create!(name: "Example User",
            email: "example@mynextgenhealth.net",
            password: "foobar",
            password_confirmation: "foobar",
            admin: true)

  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@mynextgenhealth.net"
    password = "password"
    User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password)
  end
