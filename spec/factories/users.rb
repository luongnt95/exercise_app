require 'faker'

FactoryGirl.define do
  factory :user do
    name "user"
    email "user@example.com"
    password "123456"
    activated "deactivated"
    admin true
  end

  factory :invalid_user, parent: :user do
    name ""
    emai ""
  end

end
