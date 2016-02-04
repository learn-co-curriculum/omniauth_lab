require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    User.destroy_all
  end

  let(:user) {User.create(:name => "Blake", :uid => 1234567
    )}

  describe 'get create' do
    it 'creates user if it doesnt exist in the db' do
      auth = {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :email => 'joe@bloggs.com',
          :name => 'Joe Bloggs'
        }
      }
      auth = ActiveSupport::HashWithIndifferentAccess.new(auth)
      user
      @request.env['omniauth.auth'] = auth
      get :create
      expect(@request.session[:user_id]).to eq(user.id)
    end
  end
end
