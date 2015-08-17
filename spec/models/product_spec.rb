require 'rails_helper'

RSpec.describe Product, type: :model do
	it "has a valid factory" do
		FactoryGirl.create(:product).should be_valid
	end

	it "is invalid without a name" do
		FactoryGirl.build(:product, name: "").should_not be_valid	
	end

	it "is invalid with name containing special characters" do
		FactoryGirl.build(:product, name: "luon%g nguyen").should_not be_valid
	end

	it "is invalid with name's length being greater than 50" do
		FactoryGirl.build(:product, name: "a"*51).should_not be_valid
	end

	it "is invalid with name's length being smaller than 2" do
		FactoryGirl.build(:product, name: "a").should_not be_valid
	end

	it "is valid with name's length being 2" do
		FactoryGirl.build(:product, name: "ab").should be_valid
	end

	it "is invalid with name's length being 50" do
		FactoryGirl.build(:product, name: "a"*50).should be_valid
	end

	it "is invalid without activation" do
		FactoryGirl.build(:product, activated: "").should_not be_valid
	end

	it "is invalid with activated is not included in the list" do
		FactoryGirl.build(:product, activated: "abc").should_not be_valid
	end

	describe "filter product by letters" do
		before :each do
			@product1 = FactoryGirl.create(:product, id: 1, name: "product1", activated: "activated")
			@product2 = FactoryGirl.create(:product, id: 2, name: "product2")
			@product3 = FactoryGirl.create(:product, id: 3, name: "product3", activated: "activated")
			@product4 = FactoryGirl.create(:product, id: 4, name: "product4")
		end
		describe "filter product by id" do
			context "matching id" do
				it "returns a result that matches" do
					Product.search("2").should include @product2
				end
			end

			context "non-matching id" do
				it "doesn't return a product with id that doesn't exist" do
					Product.search("5").should == []
				end
			end
		end

		describe "filter product by name" do
			context "matching name" do
				it "returns an array of results that match" do
					Product.search("product2").should include @product2
				end

				it "returns an array of results that partially match" do
					Product.search("product").should == [@product1, @product2, @product3, @product4]
				end
			end

			context "non-matching name" do
				it "doesn't return a product with name that doesn't exist" do
					Product.search("abc").should == []
				end
			end
		end

		describe "filter product by price" do
			context "matching price" do
				it "returns an array of results that match" do
					Product.search("100").should == [@product1, @product2, @product3, @product4]
				end

				it "returns an array of results that partially match" do
					Product.search("1").should == [@product1, @product2, @product3, @product4]
				end
			end

			context "non-matching price" do
				it "doesn't return a product with price that doesn't exist" do
					Product.search("200").should == []
				end
			end
		end

		describe "filter product by activated" do
			context "matching activated" do
				it "returns an array of results that match" do
					Product.search("deactivated").should == [@product2, @product4]
				end

				it "returns an array of results that partially match" do
					Product.search("ac").should == [@product1, @product2, @product3, @product4]
				end
			end

		end
	end
end
