namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do #this line ensures that Rake task has access to the local Rails environment
    
    # Let's make the first user an adminstrator
    # create! behaves like normal create method, expect it raises an exception for an invalid user rather than returning false
    admin = User.create!(name: "Example User",
                        email: "example@railstutorial.org",
                        password: "foobar",
                        password_confirmation: "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "exmaple-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
                  email: email,
                  password: password,
                  password_confirmation: password)
    end
  end
end