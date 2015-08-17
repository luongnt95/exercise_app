require 'rails_helper'

RSpec.describe User, type: :model do
	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
	end

	it "is invalid without a name" do
		FactoryGirl.build(:user, name: "").should_not be_valid	
	end

	it "is invalid with name containing special characters" do
		FactoryGirl.build(:user, name: "luon%g nguyen").should_not be_valid
	end

	it "is invalid with name's length being greater than 50" do
		FactoryGirl.build(:user, name: "a"*51).should_not be_valid
	end

	it "is invalid with name's length being smaller than 2" do
		FactoryGirl.build(:user, name: "a").should_not be_valid
	end

	it "is valid with name's length being 2" do
		FactoryGirl.build(:user, name: "ab").should be_valid
	end

	it "is invalid with name's length being 50" do
		FactoryGirl.build(:user, name: "a"*50).should be_valid
	end

	it "is invalid without activation" do
		FactoryGirl.build(:user, activated: "").should_not be_valid
	end

	it "is invalid with activated is not included in the list" do
		FactoryGirl.build(:user, activated: "abc").should_not be_valid
	end

	describe "filter user by letters" do
		before :each do
			@user1 = FactoryGirl.create(:user, id: 1, name: "user1", activated: "activated")
			@user2 = FactoryGirl.create(:user, id: 2, name: "user2")
			@user3 = FactoryGirl.create(:user, id: 3, name: "user3", activated: "activated")
			@user4 = FactoryGirl.create(:user, id: 4, name: "user4")
		end
		describe "filter user by id" do
			context "matching id" do
				it "returns a result that matches" do
					User.search("2").should include @user2
				end
			end

			context "non-matching id" do
				it "doesn't return a user with id that doesn't exist" do
					User.search("5").should == []
				end
			end
		end

		describe "filter user by name" do
			context "matching name" do
				it "returns an array of results that match" do
					User.search("user2").should include @user2
				end

				it "returns an array of results that partially match" do
					User.search("user").should == [@user1, @user2, @user3, @user4]
				end
			end

			context "non-matching name" do
				it "doesn't return a user with name that doesn't exist" do
					User.search("abc").should == []
				end
			end
		end

		describe "filter user by activated" do
			context "matching activated" do
				it "returns an array of results that match" do
					User.search("deactivated").should == [@user2, @user4]
				end

				it "returns an array of results that partially match" do
					User.search("ac").should == [@user1, @user2, @user3, @user4]
				end
			end

		end
	end
end
