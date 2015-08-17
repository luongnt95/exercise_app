FactoryGirl.define do
  factory :category do
  	sequence(:name) { |n| "category#{n}" }
  	activated { "deactivated" }
  end

  factory :invalid_category, parent: :category do
  	name ""
  	activated ""
  end

end