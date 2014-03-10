namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    
    Display.create!(name: Faker::Number.number(6),
                    password: "foobar",
                    password_confirmation: "foobar")
    5.times do |n|
      name  = Faker::Number.number(6)
      description = "example-#{n+1}"
      url  = "http://localhost:8080/test/index.html"
      App.create!( name: name,
                   description: description,
                   url: url)
    end

    

  end
end
