namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do #this line ensures that Rake task has access to the local Rails environment
    
    make_users
    make_microposts
    make_relationships
    # Let's make the first user an adminstrator
    # create! behaves like normal create method, expect it raises an exception for an invalid user rather than returning false
  end
end

def make_users
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


def make_microposts
  users = User.all(limit: 99)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users  = users[2..50]
  followers       = users[3..40]
  followed_users.each   { |followed| user.follow!(followed) }
  followers.each        { |follower| follower.follow!(user) }
end