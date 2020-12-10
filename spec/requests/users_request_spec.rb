require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin){FactoryBot.create(:user, :admin)}
  let(:user){FactoryBot.create(:user, :user)}
  let!(:users){FactoryBot.create_list(:user,2)}
  let(:param_lock){"lock"}
  let(:param_unlock){"unlock"}

   # NOT ADMIN RSPEC
   describe "not admin" do
    before do
      sign_in user
    end
    before {get "/admin/users"}

    it "flash warning message" do
      expect(flash[:warning]).to eq I18n.t "message.is_admin"
    end

    it "redirect the #index view" do
      expect(response).to redirect_to :root
    end
  end

  #1 - INDEX RSPEC
  describe "GET #index" do
    before do
      sign_in admin
    end
    before {get "/admin/users"}

    it "assign @user" do
      expect(assigns(:users)).to be_truthy
    end

    it "renders the #index view" do
      expect(response).to render_template :index
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end
  end
  #2 - UPDATE RSPEC
  describe "PATCH #update" do
    before do
      sign_in admin
    end

    context "not found user" do
      before do
        patch "/admin/users/1000",
        params: {type: param_lock,id: 1000}
      end

      it "redirect admin_users_path" do
        expect(response.body).to include("window.location='/vi/admin/users'")
      end
    end

    context "banner user success" do
      before do
        headers = { "ACCEPT" => "application/json" }
        patch "/admin/users/#{user.id}",
        params: {type: param_lock,id: user.id},
        :headers => headers
      end
      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "have content type response is json" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "banner user fail" do
      before do
        allow_any_instance_of(User).to receive(:update_columns).and_return(false)
        patch "/admin/users/#{user.id}",
        params: {type: param_lock,id: user.id}
      end

      it "redirect admin_users_path" do
        expect(response.body).to include("window.location='/vi/admin/users'")
      end
    end

    context "check param banner fail" do
      before do
        patch "/admin/users/#{user.id}",
        params: {type: param_unlock,id: user.id}
      end

      it "redirect admin_users_path" do
        expect(response.body).to include("window.location='/vi/admin/users'")
      end
    end

  end
end
