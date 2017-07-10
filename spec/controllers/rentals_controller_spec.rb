require 'spec_helper'

RSpec.describe ::RentalsController, type: :controller do
  before (:each) do
  end

  describe "GET #index" do
    it "returns a success response" do
      rental = Rental.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
    end
  end

  describe "GET #new" do
    it "returns a success response" do
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
    end
  end

  describe "POST #create" do
    it "returns a success response" do
    end
  end

  describe "PUT #update" do

  end

  describe "DELETE #destroy" do
    it "destroys the requested rental" do
      rental = Rental.create! valid_attributes
      expect {
        delete :destroy, {:id => rental.to_param}, valid_session
      }.to change(Rental, :count).by(-1)
    end

    it "redirects to the rentals list" do
      rental = Rental.create! valid_attributes
      delete :destroy, {:id => rental.to_param}, valid_session
      expect(response).to redirect_to(rentals_url)
    end
  end

end
