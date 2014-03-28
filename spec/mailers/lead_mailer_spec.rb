require "spec_helper"

describe LeadMailer do
  describe "new" do
    let(:lead) { create(:lead) }
    let(:mail) { LeadMailer.new(lead) }

    it "renders the headers" do
      # mail.subject.should eq("New")
      mail.to.should eq([lead.email])
      # mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include("Thanks")
    end
  end

end
