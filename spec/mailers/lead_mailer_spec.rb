require "spec_helper"

describe LeadMailer do
  describe "new" do
    let(:lead) { create(:lead) }
    let(:mail) { LeadMailer.new(lead) }

    it "renders the headers" do
      mail.subject.should eq("Thanks!")
      mail.to.should eq([lead.email])
      mail.from.should eq([ENV["ADMIN_EMAIL"]])
    end

    it "renders the body" do
      mail.body.encoded.should include("Thanks")
    end

    it "should contain the user's message in the mail body" do
      mail.should have_body_text(/Thanks/)
    end

    ## another way to write email header test
    # it "should be set to be delivered to the email passed in" do
    #   @email.should deliver_to("jojo@yahoo.com")
    # end

    # it "should have the correct subject" do
    #   @email.should have_subject(/Account confirmation/)
    # end
  end

end
