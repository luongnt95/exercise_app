require "faker"

FactoryGirl.define do
	factory :product do
		sequence(:name) { |n| "category#{n}" }
		price 100
		description "description"
		activated "deactivated"
	end

	factory :invalid_product, parent: :product do
		name ""
		price ""
		description ""
		actiavted ""
	end

end
