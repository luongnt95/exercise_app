require 'rails_helper'

RSpec.feature "Product", type: :feature do
	before :each do
		FactoryGirl.reload unless FactoryGirl.factories.blank?
		@product1 = FactoryGirl.create(:product, id: 1)
		@product2 = FactoryGirl.create(:product, id: 2)
		@product3 = FactoryGirl.create(:product, id: 3, activated: "activated")
		@product4 = FactoryGirl.create(:product, id: 4, activated: "activated")
		log_in_user
		visit products_url
	end
	
	feature "Add Product" do
		scenario "adding product with valid data" do
			click_link 'Add Product'
			fill_in 'product_name', with: "laptop"
			fill_in 'product_description', with: "It's beautiful"
			fill_in 'product_price', with: 120.5
			select "Activate", from: 'product_activated'
			click_button 'Create'
			page.should have_content "Add product successfully!"
		end

		scenario "missing product's name" do
			click_link 'Add Product'
			fill_in 'product_name', with: ""
			fill_in 'product_description', with: "It's beautiful"
			fill_in 'product_price', with: 120.5
			select "Activate", from: 'product_activated'
			click_button 'Create'
			page.should_not have_content "Add product successfully!"
		end

		scenario "missing product's activated field" do
			click_link 'Add Product'
			fill_in 'product_name', with: "laptop"
			fill_in 'product_description', with: "It's beautiful"
			fill_in 'product_price', with: 120.5
			select "choose an option...", from: 'product_activated'
			click_button 'Create'
			page.should_not have_content "Add product successfully!"
		end
	end

	feature "Edit Product" do
		before :each do
			first(:link, 'Edit').click
		end

		context "Edit with valid data" do
			scenario "updating name" do
				fill_in 'product_name', with: "user"
				click_button 'Update'
				page.should have_content "Update product successfully!"
			end

			scenario "updating activated" do
				select "Activate", from: 'product_activated'
				click_button 'Update'
				page.should have_content "Update product successfully!"
			end
		end

		context "Edit with invalid data" do
			scenario "missing name" do
				fill_in 'product_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update product successfully!"
			end

			scenario "missing activated" do
				fill_in 'product_name', with: ""
				click_button 'Update'
				page.should_not have_content "Update product successfully!"
			end

			scenario "containing special charaters" do
				fill_in 'product_name', with: "lap%top"
				click_button 'Update'
				page.should_not have_content "Update product successfully!"
			end
		end
	end

	feature "Bulk action" do

		context "Activate" do
			it "activates products that are checked" do
				find('#item-row-1').check 'ids[]'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"		
			end

			it "activates all products if ID field is checked" do
				check 'check_all'
				click_button 'Activate'
				find('#item-row-1').should have_content "Activated"
				find('#item-row-2').should have_content "Activated"
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Activated"
			end
		end

		context "Deactivate" do
			it "deactivates products that are checked" do
				find('#item-row-4').check 'ids[]'
				click_button 'Delete'
				find('#item-row-1').should have_content "Deactivated"
				find('#item-row-2').should have_content "Deactivated"	
				find('#item-row-3').should have_content "Activated"
				find('#item-row-4').should have_content "Deactivated"
			end 

			it "deactivates all products if ID field is checked" do
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
				@product1.name.should appear_before(@product4.name)
			end

			it "sorts in reverse direction when clicking ID" do
				click_link 'ID'
				@product4.name.should appear_before(@product1.name)
			end

			it "sorts in default direction after double-clicking" do
				click_link 'ID'
				click_link 'ID'
				@product1.name.should appear_before(@product4.name)
			end
		end

		context "sort by name" do
			it "sorts in default direction" do
				@product1.name.should appear_before(@product4.name)
			end

			it "sorts in reverse direction" do
				click_link 'Product Name'
				@product4.name.should appear_before(@product1.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'Product Name'
				click_link 'Product Name'
				@product1.name.should appear_before(@product4.name)
			end
		end

		context "sort by activated" do
			it "sort in default" do
				@product1.name.should appear_before(@product4.name)
			end

			it "sorts in desc direction" do
				click_link 'Activate'
				@product1.name.should appear_before(@product4.name)
			end

			it "sorts in default direction after double-clinking" do
				click_link 'Activate'
				click_link 'Activate'
				@product4.name.should appear_before(@product1.name)
			end
		end
	end

	feature "search" do
		context "with normal format of search's input" do
			it "should show only product3's info in search results" do
				fill_in 'search', with: "3"
				click_button 'Search'
				page.should have_content @product3.name
				page.should_not have_content @product1.name
				page.should_not have_content @product2.name
				page.should_not have_content @product4.name
			end
		end

		context "with special format of search's input" do
			it "should show only product3's info in search results" do
				fill_in 'search', with: "  3  "
				click_button 'Search'
				page.should have_content @product3.name
				page.should_not have_content @product1.name
				page.should_not have_content @product2.name
				page.should_not have_content @product4.name
			end
		end
	end

end
