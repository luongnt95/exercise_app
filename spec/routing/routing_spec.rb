require 'rails_helper'

RSpec.describe "Routing", :type => :routing do
  it "routes to 404 when routing to wrong controller" do
    get('/invalid').should route_to(controller: "application", action: "raise_not_found", unmatched_route: "invalid")
  end

  describe "Category Routing" do
    context "matching routing" do
      it "routes to #index" do
        get("/categories").should route_to("categories#index")
      end

      it "routes to #new" do
        get("/categories/new").should route_to("categories#new")
      end

      it "routes to #edit" do
        get("/categories/1/edit").should route_to("categories#edit", :id => "1")
      end

      it "routes to #create" do
        post("/categories").should route_to("categories#create")
      end

      it "routes to #update" do
        put("/categories/1").should route_to("categories#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/categories/1").should route_to("categories#destroy", :id => "1")
      end

      it "routes to #bulkaction" do
        post("/categories/bulk_action").should route_to("categories#bulk_action")
      end
    end

    context "unmatching routing" do
      it "routes to 404 when routing to show action" do
        get('categories/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"categories/invalid")
      end

      it "routes to 404 when routing to wrong action" do
        get('categories/1/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"categories/1/invalid")
      end
    end
  end

  describe "Product Routing" do
    context "matching routing" do
      it "routes to #index" do
        get("/products").should route_to("products#index")
      end

      it "routes to #new" do
        get("/products/new").should route_to("products#new")
      end

      it "routes to #edit" do
        get("/products/1/edit").should route_to("products#edit", :id => "1")
      end

      it "routes to #create" do
        post("/products").should route_to("products#create")
      end

      it "routes to #update" do
        put("/products/1").should route_to("products#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/products/1").should route_to("products#destroy", :id => "1")
      end

      it "routes to #bulkaction" do
        post("/products/bulk_action").should route_to("products#bulk_action")
      end
    end

    context "unmatching routing" do
      it "routes to 404 when routing to show action" do
        get('products/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"products/invalid")
      end

      it "routes to 404 when routing to wrong action" do
        get('products/1/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"products/1/invalid")
      end
    end
  end

  describe "User Routing" do
    context "matching routing" do
      it "routes to #index" do
        get("/users").should route_to("users#index")
      end

      it "routes to #new" do
        get("/users/new").should route_to("users#new")
      end

      it "routes to #edit" do
        get("/users/1/edit").should route_to("users#edit", :id => "1")
      end

      it "routes to #create" do
        post("/users").should route_to("users#create")
      end

      it "routes to #update" do
        put("/users/1").should route_to("users#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/users/1").should route_to("users#destroy", :id => "1")
      end

      it "routes to #bulkaction" do
        post("/users/bulk_action").should route_to("users#bulk_action")
      end
    end

    context "unmatching routing" do
      it "routes to 404 when routing to show action" do
        get('users/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"users/invalid")
      end

      it "routes to 404 when routing to wrong action" do
        get('users/1/invalid').should route_to("controller"=>"application", "action"=>"raise_not_found", "unmatched_route"=>"users/1/invalid")
      end
    end
  end

end