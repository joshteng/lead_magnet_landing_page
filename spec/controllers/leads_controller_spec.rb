require 'spec_helper'

describe LeadsController do
  describe "GET #new" do
    before :each do
      get :new
    end

    it "assigns a new Lead to @lead" do
      expect(assigns(:lead)).to be_a_new(Lead)
    end

    it "render the :new template" do
      expect(response).to render_template :new
    end
  end
end
