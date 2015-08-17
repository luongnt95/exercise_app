require 'rails_helper'

RSpec.feature "Log in", type: :feature do
  background do
  	@admin = FactoryGirl.create(:user)
  	visit root_url
  end

  scenario "Logging in with correct credentials" do
  	fill_in 'session_name', with: @admin.name
  	fill_in 'session_password', with: @admin.password
  	click_button 'Login'
  	page.should_not have_content "Invalid name/password combination. Please log in again!"
  	page.should have_content "Hi, #{@admin.name}"
  end

  given(:other_user) { FactoryGirl.create(:user, name: "other") }

  scenario "Logging in with incorrect username" do
  	fill_in 'session_name', with: other_user.name
  	fill_in 'session_password', with: other_user.password
  	click_button 'Login'
  	page.should have_content "Invalid name/password combination. Please log in again!"
  	page.should_not have_content "Hi, #{other_user.name}"
  end

  given(:other_user) { FactoryGirl.create(:user, password: "123457") }

  scenario "Logging in with incorrect password" do
  	fill_in 'session_name', with: other_user.name
  	fill_in 'session_password', with: other_user.password
  	click_button 'Login'
  	page.should have_content "Invalid name/password combination. Please log in again!"
  	page.should_not have_content "Hi, #{other_user.name}"
  end
end
