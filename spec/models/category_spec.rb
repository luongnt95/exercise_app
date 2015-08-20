require 'rails_helper'

RSpec.describe Category, type: :model do
	it "has a valid factory" do
		FactoryGirl.create(:category).should be_valid
	end

	it "is invalid without a name" do
		FactoryGirl.build(:category, name: "").should_not be_valid	
	end

	it "is invalid with name containing special characters" do
		FactoryGirl.build(:category, name: "luon%g nguyen").should_not be_valid
	end

	it "is invalid with name's length being greater than 50" do
		FactoryGirl.build(:category, name: "a"*51).should_not be_valid
	end

	it "is invalid with name's length being smaller than 2" do
		FactoryGirl.build(:category, name: "a").should_not be_valid
	end

	it "is valid with name's length being 2" do
		FactoryGirl.build(:category, name: "ab").should be_valid
	end

	it "is invalid with name's length being 50" do
		FactoryGirl.build(:category, name: "a"*50).should be_valid
	end

	it "is invalid without activation" do
		FactoryGirl.build(:category, activated: "").should_not be_valid
	end

	it "is invalid with activated is not included in the list" do
		FactoryGirl.build(:category, activated: "abc").should_not be_valid
	end

	before :each do
		@category1 = FactoryGirl.create(:category, id: 1, name: "category1", activated: "activated")
		@category2 = FactoryGirl.create(:category, id: 2, name: "category2")
		@category3 = FactoryGirl.create(:category, id: 3, name: "category3", activated: "activated")
		@category4 = FactoryGirl.create(:category, id: 4, name: "category4")
	end

	describe "filter category by letters" do
		describe "filter category by id" do
			context "matching id" do
				it "returns a result that matches" do
					Category.search("2").should include @category2
				end
			end

			context "non-matching id" do
				it "doesn't return a category with id that doesn't exist" do
					Category.search("5").should == []
				end
			end
		end

		describe "filter category by name" do
			context "matching name" do
				it "returns an array of results that match" do
					Category.search("category2").should include @category2
				end

				it "returns an array of results that partially match" do
					Category.search("category").should == [@category1, @category2, @category3, @category4]
				end
			end

			context "non-matching name" do
				it "doesn't return a category with name that doesn't exist" do
					Category.search("abc").should == []
				end
			end
		end

		describe "filter category by activated" do
			context "matching activated" do
				it "returns an array of results that match" do
					Category.search("deactivated").should == [@category2, @category4]
				end

				it "returns an array of results that partially match" do
					Category.search("ac").should == [@category1, @category2, @category3, @category4]
				end
			end

		end
	end

end
