require 'rails_helper'

RSpec.feature "Product Pagination", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@product1 = FactoryGirl.create(:product, id: 1, name: "product1")
		@product2 = FactoryGirl.create(:product, id: 2, name: "product2")
		@product3 = FactoryGirl.create(:product, id: 3, name: "product3", activated: "activated")
		@product4 = FactoryGirl.create(:product, id: 4, name: "product4", activated: "activated")
		@product5 = FactoryGirl.create(:product, id: 5, name: "product5", activated: "activated")
		@product6 = FactoryGirl.create(:product, id: 6, name: "product6", activated: "activated")
		log_in_user
		visit products_url
	end

	it "shows page 2 after clicking paginate-link 2" do
		within('div.pagination') do
			click_link '2'
		end
		page.should have_content @product6.name
		page.should_not have_content @product1.name
		page.should_not have_content @product2.name
		page.should_not have_content @product3.name
		page.should_not have_content @product4.name
		page.should_not have_content @product5.name
	end

	it "shows page 2 after sorting by id" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'ID'

		page.should have_content @product1.name
		page.should_not have_content @product6.name
		page.should_not have_content @product2.name
		page.should_not have_content @product3.name
		page.should_not have_content @product4.name
		page.should_not have_content @product5.name
	end

	it "shows page 2 after sorting by activated" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'Activate'
		click_link 'Activate'
		page.should have_content @product2.name
		page.should_not have_content @product6.name
		page.should_not have_content @product1.name
		page.should_not have_content @product3.name
		page.should_not have_content @product4.name
		page.should_not have_content @product5.name
	end

end