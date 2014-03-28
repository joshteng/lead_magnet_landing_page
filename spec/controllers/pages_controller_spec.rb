require 'spec_helper'

describe PagesController do
  describe "GET #thank_you" do
    it "render :thank_you template" do
      get :thank_you
      expect(response).to render_template :thank_you
    end

    it "assigns a lead if lead is passed in paramter" do
      lead = create(:lead)
      get :thank_you, ref: lead.id
      expect(assigns[:lead]).to eq(lead)
    end
  end

end