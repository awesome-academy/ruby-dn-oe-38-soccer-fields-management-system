require "rails_helper"

RSpec.describe "User::Bookings", type: :request do
  let!(:user){FactoryBot.create(:user, :user)}
  let(:user_1){FactoryBot.create(:user, :user)}
  let(:bookings){Bookings.all}
  let!(:location){FactoryBot.create(:location)}
  let!(:yard){FactoryBot.create(:yard)}
  let!(:time_cost){FactoryBot.create(:time_cost)}
  let!(:booked){FactoryBot.create(:booking, :today)}
  let!(:booking){FactoryBot.create(:booking, :next_date)}
  let!(:booking_accept){FactoryBot.create(:booking, :accept)}

  before do
    sign_in user
  end

  #1 - INDEX RSPEC
  describe "GET #index" do
    before {get "/user/bookings"}

    it "assign @booking" do
      expect(assigns(:bookings)).to be_truthy
    end

    it "renders the #index view" do
      expect(response).to render_template :index
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end
  end

  #2 - CREATE RSPEC
  describe "POST #create" do
    context "param time invalid" do
      before do
        headers = { "ACCEPT" => "application/json" }
        post "/user/bookings",
        params: {time: (Time.now.hour - 1), date: Date.today.to_s, id_timecost: time_cost.id},
        :headers => headers
      end

      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "return message fail" do
        message = "{\"title\":\"#{I18n.t("message.booking.booking_fail")}\",\"content\":\"#{I18n.t("message.booking.booking_logic")}\"}"
        expect(response.body).to eq(message)
      end
    end

    context "booking exist" do
      before do
        headers = { "ACCEPT" => "application/json" }
        post "/user/bookings",
        params: {time: time_cost.time, date: booking.booking_date, id_timecost: time_cost.id},
        :headers => headers
      end

      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "return message fail" do
        message = "{\"title\":\"#{I18n.t("message.booking.booking_fail")}\",\"content\":\"#{I18n.t("message.booking.booking_fail_mess")}\"}"
        expect(response.body).to eq(message)
      end
    end

    context "create booking success" do
      before do
        headers = { "ACCEPT" => "application/json" }
        post "/user/bookings",
        params: {time: time_cost.time, date: (Date.today+2).to_s, id_timecost: time_cost.id},
        :headers => headers
      end

      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "return message success" do
        message = "{\"success\":true,\"title\":\"#{I18n.t("message.booking.booking_succ")}\",\"content\":\"#{I18n.t("message.booking.booking_succ_mess")}\"}"
        expect(response.body).to eq(message)
      end
    end

    context "create booking fail" do
      before do
        allow_any_instance_of(Booking).to receive(:save).and_return(false)
        headers = { "ACCEPT" => "application/json" }
        post "/user/bookings",
        params: {time: time_cost.time, date: (Date.today+2).to_s, id_timecost: time_cost.id},
        :headers => headers
      end

      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "return message fail" do
        message = "{\"title\":\"#{I18n.t("message.booking.booking_fail")}\",\"content\":\"#{I18n.t("message.booking.booking_fail_mess")}\"}"
        expect(response.body).to eq(message)
      end
    end
  end

  # UPDATE RSPEC
  describe "UPDATE #update" do

    context "booking invalid" do
      before do
        patch "/user/bookings/5",
        params: {id: 5}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.update_booking.not_exist_id"
      end

      it "redirect the #index view" do
        expect(response).to redirect_to :user_bookings
      end
    end

    context "params status invalid" do
      before do
        patch "/user/bookings/#{booking.id}",
        params: {id: booking.id, stt: "update"}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.update_booking.check_status_edit"
      end

      it "redirect the #index view" do
        expect(response).to redirect_to :user_bookings
      end
    end

    context "params current user invalid" do
      before do
        sign_out user
        sign_in user_1
        patch "/user/bookings/#{booking.id}",
        params: {id: booking.id, stt: "cancel"}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.update_booking.check_current_user"
      end

      it "redirect the #index view" do
        expect(response).to redirect_to :user_bookings
      end
    end

    context "status booking no pending" do
      before do
        patch "/user/bookings/#{booking_accept.id}",
        params: {id: booking_accept.id, stt: "cancel"}
      end

      it "flash warning message" do
        expect(flash[:warning]).to eq I18n.t "message.update_booking.check_status"
      end

      it "redirect the #index view" do
        expect(response).to redirect_to :user_bookings
      end
    end

    context "update success" do
      before do
        headers = { "ACCEPT" => "application/json" }
        patch "/user/bookings/#{booking.id}",
        params: {id: booking.id, stt: "cancel"},
        :headers => headers
      end

      it "return status code symbol is create" do
        expect(response).to have_http_status(:created)
      end

      it "return object @booking" do
        expect(response.body).to be_truthy
      end
    end

    context "update fail" do
      before do
        allow_any_instance_of(Booking).to receive(:update_status).and_return(false)
        patch "/user/bookings/#{booking.id}",
        params: {id: booking.id, stt: "cancel"}
      end

      it "redirect user_bookings_path" do
        expect(response.body).to include("window.location='/vi/user/bookings'")
      end
    end
  end

  #RSPEC SEARCH_YARD_FOR_BOOKING

  describe "GET #seach_yard_for_booking" do
    context "search fail" do
      before do
        # headers = { "ACCEPT" => "application/json" }
        get "/user/seach_yard_for_booking",
        # params: {location_id: 5}
        xhr: true
      end

      it "renders the booking error layout" do
        subject {get "/user/seach_yard_for_booking"}
        expect(subject).to render_template("yards/_err_yard", "user/bookings/seach_yard_for_booking")
      end
      it "render js" do
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context "search success" do
      before do
        get "/user/seach_yard_for_booking",
        params: {location_id: location.id, type_yard: yard.type_yard, hours: time_cost.time, time_cost_id: time_cost.id, date: (Date.today+2).to_s},
        xhr: true
      end

      it "renders the booking success layout" do
        subject {get "/user/seach_yard_for_booking"}
        expect(subject).to render_template("yards/_yard", "user/bookings/seach_yard_for_booking")
      end
      it "render js" do
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end
  end
end
