require 'rails_helper'

RSpec.feature "User Pagination", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@user1 = FactoryGirl.create(:user, id: 1, name: "user1", activated: "deactivated", admin: false)
		@user2 = FactoryGirl.create(:user, id: 2, name: "user2", activated: "deactivated", admin: false)
		@user3 = FactoryGirl.create(:user, id: 3, name: "user3", activated: "activated", admin: false)
		@user4 = FactoryGirl.create(:user, id: 4, name: "user4", activated: "activated", admin: false)
		@user5 = FactoryGirl.create(:user, id: 5, name: "user5", activated: "activated", admin: false)
		@user6 = FactoryGirl.create(:user, id: 6, name: "user6", activated: "activated", admin: false)
		log_in_user
		visit users_url
	end

	it "shows page 2 after clicking paginate-link 2" do
		within('div.pagination') do
			click_link '2'
		end
		page.should have_content @user6.name
		page.should_not have_content @user1.name
		page.should_not have_content @user2.name
		page.should_not have_content @user3.name
		page.should_not have_content @user4.name
		page.should_not have_content @user5.name
	end

	it "shows page 2 after sorting by id" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'ID'

		# there should be 7 users including admin
		page.should have_content @user1.name
		page.should have_content @user2.name
		page.should_not have_content @user3.name
		page.should_not have_content @user4.name
		page.should_not have_content @user5.name
		page.should_not have_content @user6.name
	end

	it "shows page 2 after sorting by activated" do
		within('div.pagination') do
			click_link '2'
		end
		click_link 'Activate'
		click_link 'Activate'
		page.should have_content @user2.name
		page.should_not have_content @user6.name
		page.should_not have_content @user1.name
		page.should_not have_content @user3.name
		page.should_not have_content @user4.name
		page.should_not have_content @user5.name
	end

end