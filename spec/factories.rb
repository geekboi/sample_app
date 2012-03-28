FactoryGirl.define do
  factory :user do
    name      "M Hartl"
    email     "m@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end