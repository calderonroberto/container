FactoryGirl.define do

  factory :display do
    name     "display"
    password "foobar"
    password_confirmation "foobar"
    setup { FactoryGirl.create(:setup) }
  end

  factory :user do
    sequence(:uid) { |n| "12345#{n}" }    
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    name { Faker::Name.name }
    sequence(:thumbnail_url) { |n| "http://graph.facebook.com/12345#{n}/picture?type=small" }
    sequence(:picture_url) { |n| "http://graph.facebook.com/12345#{n}/picture?type=large" }
    token "CAAGbdcX3vZAYBADMve5ccsk4kAJt9vBIKLlzDLATasvaPATFZBMTt58MiDWZCRQ95sAvxOwzepK3SiM1dHL4IvSTuPjvOeGZBDZA7n2KWw2jsEg3O7QUnq9qqOVcSylcBthouArs0x14wanXePaZCZBujOOjVpPoXNwMEF910c6gHW8hvgt8eH8"
    friends { ["11234", "12345", "123456"] }
  end

  factory :app do
    sequence(:name) { |n| "#{ Time.now.getutc.to_i.to_s} #{n}" }    
    description "App description"
    url "http://localhost:8080/test/index.html"
    thumbnail_url "app_thumbnail.png"
  end

  factory :setup do
    thingbroker_url "http://kimberly.magic.ubc.ca:8080/thingbroker"
  end

end
