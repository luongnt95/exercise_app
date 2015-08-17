require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
	describe 'POST #create' do
		context 'when password is invalid' do
			it 'renders the page with error' do
				user = FactoryGirl.build(:user, name: "luong", password: "invalid")

				post :create, session: { name: user.name, password: 'invalid' }

				expect(response).to render_template(:new)
        		#expect(flash[:notice]).to match(/^Email and password do not match/)
    		end
		end

		context 'when password is valid' do
			it 'sets the user in the session and redirects them to their dashboard' do
				user = FactoryGirl.create(:user, name: "luong", email: "luong@gmail.com",
					password: "123456", admin: true )

				post :create, session: { name: user.name, password: user.password }

				expect(response).to redirect_to categories_url

				expect(current_user).to eq user
			end
		end
	end
end
