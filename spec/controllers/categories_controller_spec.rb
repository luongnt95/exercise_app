require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
	before :each do
		user = FactoryGirl.create(:user, name: "luong", email: "luong@gmail.com", activated: "activated", admin: true)
		log_in user
	end

	describe "GET index" do
		it "populates an array" do
			category = FactoryGirl.create(:category)
			get :index
			assigns(:categories).should eq([category])
		end

		it "renders the index view" do
			get :index
			response.should render_template :index
		end
	end

	describe "POST create" do
		context "with valid attributes" do
			it "creates new category" do
				expect {
					post :create, category: FactoryGirl.attributes_for(:category)
				}.to change(Category, :count).by(1)
			end

			it "redirects to index view when finishing creating" do
				post :create, category: FactoryGirl.attributes_for(:category)
				response.should redirect_to categories_url
			end
		end

		context "with invalid attributes" do
			it "does not save" do
				expect {
					post :create, category: FactoryGirl.attributes_for(:invalid_category)
				}.to_not change(Category, :count)
			end
		end
	end

	describe "PUT update" do
		before :each do
			@category = FactoryGirl.create(:category, name: "OriginCategory", activated: "activated")
		end

		context "valid attributes" do
			it "located the requested" do
				put :update, id: @category, category: FactoryGirl.attributes_for(:category)
				assigns(:category).should eq(@category)
			end
		end

		it "changes attributes" do
			put :update, id: @category, category: FactoryGirl.attributes_for(:category, name: "newname", activated: "deactivated")
			@category.reload
			@category.name.should eq("newname")
			@category.activated.should eq("deactivated")
		end

		it "redirects to index view" do
			put :update, id: @category, category: FactoryGirl.attributes_for(:category)
			response.should redirect_to categories_url
		end

		context "invalid attributes" do
			it "locates the requested" do
				put :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
				assigns(:category).should eq(@category)
			end

			it "does not change attributes" do
				put :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
				@category.reload
				@category.name.should_not eq("")
				@category.name.should eq("OriginCategory")
			end

			it "re-render the edit method" do
				put :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
				response.should render_template :edit
			end
		end
	end

end
