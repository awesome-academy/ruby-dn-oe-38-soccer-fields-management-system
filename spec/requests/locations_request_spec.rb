require "rails_helper"

RSpec.describe "Admin::Locations", type: :request do
  let(:location){FactoryBot.create(:location)}
  let!(:locations){FactoryBot.create_list(:location,2)}
  let(:valid_params){FactoryBot.create(:location).serializable_hash}
  let(:invalid_params){{name: ""}}
  let(:admin){FactoryBot.create(:user, :admin)}
  let(:user){FactoryBot.create(:user, :user)}

  # NOT ADMIN RSPEC
  describe "not admin" do
    before do
      sign_in user
      # allow_any_instance_of(AdminController).to receive(:current_user).and_return(user)
    end
    before {get "/admin/locations"}

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
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    before {get "/admin/locations"}

    it "assign @locations" do
      expect(assigns(:locations)).to be_truthy
    end

    it "renders the #index view" do
      expect(response).to render_template :index
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end
  end

  #2 - NEW RSPEC
  describe "GET #new" do
    before do
      sign_in admin
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    before {get "/admin/locations/new"}

    it "assigns a new @location" do
      expect(assigns(:location)).to be_a_new(Location)
    end

    it "renders the #new view" do
      expect(response).to render_template :new
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end
  end

  #3 - EDIT RSPEC
  describe "GET #edit" do
    before do
      sign_in admin
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    context "found @location" do
      before {get "/admin/locations/#{location.id}/edit", params:{id: location.id}}

      it "assign @location" do
        expect(assigns(:location)).to eq(location)
      end

      it "renders the #edit view" do
        expect(response).to render_template :edit
      end

      it "returns a http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "not found @location" do
      before {get "/admin/locations/1000/edit", params:{id: 1000}}

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.fail"
      end

      it "redirect the #index view" do
        expect(response).to redirect_to :admin_locations
      end
    end
  end

  #4 - CREATE RSPEC
  describe "POST #create" do
    before do
      sign_in admin
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    context "create location success" do
      before do
        post "/admin/locations",
        params: {location: valid_params}
      end

      it "create a new location" do
        expect(assigns(:location)).to be_a Location
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "message.add_location"
      end

      it "redirects to the #index" do
        expect(response).to redirect_to :admin_locations
      end

    end

    context "create location fail" do
      before do
        post "/admin/locations",
        params: {location: invalid_params}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.fail"
      end

      it "re-renders the new view" do
        expect(response).to render_template :new
      end
    end
  end

  #5 - UPDATE RSPEC
  describe "PATCH #update" do
    before do
      sign_in admin
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    context "update location success" do
      before do
        patch "/admin/locations/#{location.id}",
        params: {location: valid_params,id: location.id}
      end

      it "update a location" do
        expect(assigns(:location)).to be_a Location
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "message.update_location"
      end

      it "redirects to the #index" do
        expect(response).to redirect_to :admin_locations
      end
    end

    context "update location fail" do
      before do
        patch "/admin/locations/#{location.id}",
        params: {location: invalid_params,id: location.id}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.update_fail"
      end

      it "re-renders the new view" do
        expect(response).to render_template :edit
      end
    end
  end
end
