require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
	before :each do
		user = FactoryGirl.create(:user, name: "luong", email: "luong@gmail.com", activated: "activated", admin: true)
		log_in user
	end

	describe "GET index" do
		it "populates an array" do
			product = FactoryGirl.create(:product)
			get :index
			assigns(:products).should eq([product])
		end

		it "renders the index view" do
			get :index
			response.should render_template :index
		end
	end

	describe "POST create" do
		context "with valid attributes" do
			it "creates new product" do
				expect {
					post :create, product: FactoryGirl.attributes_for(:product)
				}.to change(Product, :count).by(1)
			end

			it "redirects to index view when finishing creating" do
				post :create, product: FactoryGirl.attributes_for(:product)
				response.should redirect_to products_url
			end
		end

		context "with invalid attributes" do
			it "does not save" do
				expect {
					post :create, product: FactoryGirl.attributes_for(:invalid_product)
				}.to_not change(Product, :count)
			end
		end
	end

	describe "PUT update" do
		before :each do
			@product = FactoryGirl.create(:product, name: "OriginProduct", activated: "activated")
		end

		context "valid attributes" do
			it "located the requested" do
				put :update, id: @product, product: FactoryGirl.attributes_for(:product)
				assigns(:product).should eq(@product)
			end
		end

		it "changes attributes" do
			put :update, id: @product, product: FactoryGirl.attributes_for(:product, name: "newname", activated: "deactivated")
			@product.reload
			@product.name.should eq("newname")
			@product.activated.should eq("deactivated")
		end

		it "redirects to index view" do
			put :update, id: @product, product: FactoryGirl.attributes_for(:product)
			response.should redirect_to products_url
		end

		context "invalid attributes" do
			it "locates the requested" do
				put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
				assigns(:product).should eq(@product)
			end

			it "does not change attributes" do
				put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
				@product.reload
				@product.name.should_not eq("")
				@product.name.should eq("OriginProduct")
			end

			it "re-render the edit method" do
				put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
				response.should render_template :edit
			end
		end
	end
end
