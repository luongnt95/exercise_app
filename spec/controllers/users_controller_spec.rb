require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before :each do
    user = FactoryGirl.create(:user, name: "luong", email: "luong@gmail.com", activated: "activated", admin: true)
	  log_in user
  end
  

  describe "GET index" do

    it "renders the :index view" do 
      get :index
      response.should render_template :index
    end
  end



  describe "POST create" do 

    context "with valid attributes" do
      it "create new user" do 
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "redirects to index view when finishing creating" do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to users_url
      end
    end


    context "with invalid attributes" do
      it "does not save" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
        }.to_not change(User,:count)
      end
    end
  end




  describe "PUT update" do

    before :each do
      @user = FactoryGirl.create(:user, name: "Originuser", activated: "activated")
    end

    context "valid attributes" do
      it "located the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        assigns(:user).should eq(@user)
      end
    end

    it "changes attributes" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, name: "newname", 
                                                                        activated: "deactivated")
      @user.reload
      @user.name.should eq("newname")
      @user.activated.should eq("deactivated")
    end

    it "redirects to index view" do 
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      response.should redirect_to users_url
    end

    context "invalid attributes" do
      it "locates the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        assigns(:user).should eq(@user)    
      end
      it "does not change attributes" do
        put :update,id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        @user.reload
        @user.name.should_not eq("newname")
        @user.name.should eq("Originuser")
      end
      it "re-render the edit method" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        response.should render_template :edit
      end
    end
  end
end
