RSpec.feature "Category Pagination", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@category1 = FactoryGirl.create(:category, id: 1)
		@category2 = FactoryGirl.create(:category, id: 2)
		@category3 = FactoryGirl.create(:category, id: 3, activated: "activated")
		@category4 = FactoryGirl.create(:category, id: 4, activated: "activated")
		@category5 = FactoryGirl.create(:category, id: 5, activated: "activated")
		@category6 = FactoryGirl.create(:category, id: 6, activated: "activated")
		log_in_user
	end

	it "shows page 2 after clicking paginate-link 2" do
		within('div.pagination') do
			click_link '2'
		end
		page.should have_content @category6.name
		page.should_not have_content @category1.name
		page.should_not have_content @category2.name
		page.should_not have_content @category3.name
		page.should_not have_content @category4.name
		page.should_not have_content @category5.name
	end

	it "shows page 2 after sorting by id" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'ID'

		page.should have_content @category1.name
		page.should_not have_content @category6.name
		page.should_not have_content @category2.name
		page.should_not have_content @category3.name
		page.should_not have_content @category4.name
		page.should_not have_content @category5.name
	end

	it "shows page 2 after sorting by activated" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'Activate'
		click_link 'Activate'
		page.should have_content @category2.name
		page.should_not have_content @category6.name
		page.should_not have_content @category1.name
		page.should_not have_content @category3.name
		page.should_not have_content @category4.name
		page.should_not have_content @category5.name
	end
end