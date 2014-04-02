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
      expect(response).to render_template(:new)
    end
  end


  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new lead in the database", :vcr do
        expect{ post :create, lead: attributes_for(:lead) }.to change(Lead, :count).by(1)
      end

      it "emails the lead", :vcr do
        # expect(Lead.any_instance).to receive(:send_welcome_email) #doesnt work
        expect_any_instance_of(Lead).to receive(:send_welcome_email)
        # Lead.any_instance.should_receive(:send_welcome_email)
        post :create, lead: attributes_for(:lead)
      end

      it "adds the lead to mailchimp" do
        Lead.any_instance.should_receive(:add_to_mailchimp)
        post :create, lead: attributes_for(:lead)
      end

      it "redirects to lead#show", :vcr do
        post :create, lead: attributes_for(:lead)
        expect(response).to redirect_to thank_you_path(ref: assigns[:lead])
      end

    end

    context "with invalid attributes" do
      it "does not save the new contact in the database" do
        expect{ post :create, lead: attributes_for(:invalid_lead) }.to_not change(Lead, :count)
      end

      it "re-renders the :new template" do
        post :create, lead: attributes_for(:invalid_lead)
        expect(response).to render_template(:new)
      end
    end
  end
end
