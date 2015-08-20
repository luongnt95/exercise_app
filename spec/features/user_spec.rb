require 'rails_helper'

RSpec.feature "User", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@user1 = FactoryGirl.create(:user, id: 1, name: "user1", admin: false)
		@user2 = FactoryGirl.create(:user, id: 2, name: "user2", admin: false)
		@user3 = FactoryGirl.create(:user, id: 3, name: "user3", activated: "activated", admin: false)
		@user4 = FactoryGirl.create(:user, id: 4, name: "user4", activated: "activated", admin: false)
		log_in_user
		visit users_url
	end
	
	feature "Add User" do
		scenario "adding user with valid data" do
			click_link 'Add User'
			fill_in 'user_name', with: "user"
			fill_in 'user_password', with: "123456"
			fill_in 'user_email', with: "user@gmail.com"
			select "Activate", from: 'user_activated'
			click_button 'Create'
			page.should have_content "Add user successfully!"
		end

		scenario "missing user's name" do
			click_link 'Add User'
			fill_in 'user_name', with: ""
			select "Activate", from: 'user_activated'
			click_button 'Create'
			page.should_not have_content "Add user successfully!"
		end

		scenario "missing user's activated field" do
			click_link 'Add User'
			fill_in 'user_name', with: "user"
			fill_in 'user_password', with: "123456"
			fill_in 'user_email', with: "user@gmail.com"
			select "choose an option...", from: 'user_activated'
			click_button 'Create'
			page.should_not have_content "Add user successfully!"
		end
	end

	feature "Edit User" do

		background do
			first(:link, 'Edit').click
		end

		context "Edit with valid data" do
			scenario "updating name" do
				fill_in 'user_name', with: "user"
				click_button 'Update'
				page.should have_content "Update user successfully!"
			end

			scenario "updating activated" do
				select "Activate", from: 'user_activated'
				click_button 'Update'
				page.should have_content "Update user successfully!"
			end
		end

		context "Edit with invalid data" do
			scenario "missing name" do
				fill_in 'user_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update user successfully!"
			end

			scenario "missing activated" do
				fill_in 'user_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update user successfully!"
			end

			scenario "containing special charaters" do
				fill_in 'user_name', with: "lap%top"
				click_button 'Update'
				page.should_not have_content "Update user successfully!"
			end
		end
	end

	feature "Bulk action" do

		context "Activate" do
			it "activates users that are checked" do
				find('#item-row-1').check 'ids[]'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"		
			end

			it "activates all users if ID field is checked" do
				check 'check_all'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Activated"
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"
			end
		end

		context "Deactivate" do
			it "deactivates users that are checked" do
				find('#item-row-4').check 'ids[]'
				click_button 'Delete'
				find('#item-row-1').should have_content "Deactivated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Deactivated"
			end 

			it "deactivates all users if ID field is checked" do
				check 'check_all'
				click_button 'Delete'
				find('#item-row-1').should have_content "Deactivated"
				find('#item-row-2').should have_content "Deactivated"
				find('#item-row-3').should have_content "Deactivated"
				find('#item-row-4').should have_content "Deactivated"
			end
		end
	end

	feature "sort column" do
		context "sort by id" do
			it "sorts in default direction which is acs" do
				@user1.name.should appear_before(@user4.name)
			end

			it "sorts in reverse direction when clicking ID" do
				click_link 'ID'
				@user4.name.should appear_before(@user1.name)
			end

			it "sorts in default direction after double-clicking" do
				click_link 'ID'
				click_link 'ID'
				@user1.name.should appear_before(@user4.name)
			end
		end

		context "sort by name" do
			it "sorts in default direction" do
				@user1.name.should appear_before(@user4.name)
			end

			it "sorts in reverse direction" do
				click_link 'User Name'
				@user4.name.should appear_before(@user1.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'User Name'
				click_link 'User Name'
				@user1.name.should appear_before(@user4.name)
			end
		end

		context "sort by activated" do
			it "sort in default" do
				@user1.name.should appear_before(@user4.name)
			end

			it "sorts in desc direction" do
				click_link 'Activate'
				@user1.name.should appear_before(@user4.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'Activate'
				click_link 'Activate'
				@user4.name.should appear_before(@user1.name)
			end
		end
	end

	feature "search" do
		context "with normal format of search's input" do
			it "should show only user3's info in search results" do
				fill_in 'search', with: "3"
				click_button 'Search'
				page.should have_content @user3.name
				page.should_not have_content @user1.name
				page.should_not have_content @user2.name
				page.should_not have_content @user4.name
			end
		end

		context "with special format of search's input" do
			it "should show only user3's info in search results" do
				fill_in 'search', with: "  3  "
				click_button 'Search'
				page.should have_content @user3.name
				page.should_not have_content @user1.name
				page.should_not have_content @user2.name
				page.should_not have_content @user4.name
			end
		end
	end

end
