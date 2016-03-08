require 'rails_helper'

RSpec.describe RecentCreatedProjectsController, type: :controller do
  describe '#index' do
    it "アクセスできること" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
