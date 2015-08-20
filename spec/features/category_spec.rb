require 'rails_helper'

RSpec.feature "Category", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@category1 = FactoryGirl.create(:category, id: 1)
		@category2 = FactoryGirl.create(:category, id: 2)
		@category3 = FactoryGirl.create(:category, id: 3, activated: "activated")
		@category4 = FactoryGirl.create(:category, id: 4, activated: "activated")
		log_in_user
	end
	
	feature "Add Category" do
		scenario "adding category with valid data" do
			click_link 'Add Category'
			fill_in 'category_name', with: "laptop"
			select "Activate", from: 'category_activated'
			click_button 'Create'
			page.should have_content "Add category successfully!"
		end

		scenario "missing category's name" do
			click_link 'Add Category'
			fill_in 'category_name', with: ""
			select "Activate", from: 'category_activated'
			click_button 'Create'
			page.should_not have_content "Add category successfully!"
		end

		scenario "missing category's activated field" do
			click_link 'Add Category'
			fill_in 'category_name', with: "laptop"
			select "choose an option...", from: 'category_activated'
			click_button 'Create'
			page.should_not have_content "Add category successfully!"
		end
	end

	feature "Edit Category" do
		before :each do
			first(:link, 'Edit').click
		end

		context "Edit with valid data" do
			scenario "updating name" do
				fill_in 'category_name', with: "user"
				click_button 'Update'
				page.should have_content "Update category successfully!"
			end

			scenario "updating activated" do
				select "Activate", from: 'category_activated'
				click_button 'Update'
				page.should have_content "Update category successfully!"
			end
		end

		context "Edit with invalid data" do
			scenario "missing name" do
				fill_in 'category_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update category successfully!"
			end

			scenario "missing activated" do
				fill_in 'category_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update category successfully!"
			end

			scenario "containing special charaters" do
				fill_in 'category_name', with: "lap%top"
				click_button 'Update'
				page.should_not have_content "Update category successfully!"
			end
		end
	end

	feature "Bulk action" do

		context "Activate" do
			it "activates categories that are checked" do
				find('#item-row-1').check 'ids[]'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"		
			end

			it "activates all categories if ID field is checked" do
				check 'check_all'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Activated"
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"
			end
		end

		context "Deactivate" do
			it "deactivates categories that are checked" do
				find('#item-row-4').check 'ids[]'
				click_button 'Delete'
				find('#item-row-1').should have_content "Deactivated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Deactivated"
			end 

			it "deactivates all categories if ID field is checked" do
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
				@category1.name.should appear_before(@category4.name)
			end

			it "sorts in reverse direction when clicking ID" do
				click_link 'ID'
				@category4.name.should appear_before(@category1.name)
			end

			it "sorts in default direction after double-clicking" do
				click_link 'ID'
				click_link 'ID'
				@category1.name.should appear_before(@category4.name)
			end
		end

		context "sort by name" do
			it "sorts in default direction" do
				@category1.name.should appear_before(@category4.name)
			end

			it "sorts in reverse direction" do
				click_link 'Category Name'
				@category4.name.should appear_before(@category1.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'Category Name'
				click_link 'Category Name'
				@category1.name.should appear_before(@category4.name)
			end
		end

		context "sort by activated" do
			it "sort in default" do
				@category1.name.should appear_before(@category4.name)
			end

			it "sorts in desc direction" do
				click_link 'Activate'
				@category1.name.should appear_before(@category4.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'Activate'
				click_link 'Activate'
				@category4.name.should appear_before(@category1.name)
			end
		end
	end

	feature "search" do
		context "with normal format of search's input" do
			it "should show only category3's info in search results" do
				fill_in 'search', with: "3"
				click_button 'Search'
				page.should have_content @category3.name
				page.should_not have_content @category1.name
				page.should_not have_content @category2.name
				page.should_not have_content @category4.name
			end
		end

		context "with special format of search's input" do
			it "should show only category3's info in search results" do
				fill_in 'search', with: "  3  "
				click_button 'Search'
				page.should have_content @category3.name
				page.should_not have_content @category1.name
				page.should_not have_content @category2.name
				page.should_not have_content @category4.name
			end
		end
	end

end
