FactoryGirl.define do
  factory :display do
    name     "display"
    password "foobar"
    password_confirmation "foobar"
  end
  
  factory :app do
    sequence(:name) { |n| "#{Time.now.strftime("%Y%j%I%M%S")} #{n}" }    
    description "App description"
    url "http://localhost:8080/test/index.html"
    thumbnail_url "http://localhost/test.jpeg"
  end 

end
