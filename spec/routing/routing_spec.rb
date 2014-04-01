require 'spec_helper'

describe "Routing" do

  specify "homepage routes to leads#new" do
    expect(get: '/').to route_to(controller: "leads", action: "new")
  end

  context "pages controller" do
    specify "get /thank-you routes to thank you page" do
      expect(get: "/thank-you").to route_to(controller: "pages", action: "thank_you")
    end
  end

  context "leads controller" do
    specify "post /leads routes to leads#create" do
      expect(post: '/leads').to route_to(controller: "leads", action: "create")
    end

    specify "no other routes exists" do
      expect(get: '/leads/1').not_to be_routable
      expect(get: '/leads').not_to be_routable
      expect(get: '/leads/new').not_to be_routable
      expect(get: '/leads/1/edit').not_to be_routable
      expect(put: '/leads/1').not_to be_routable
      expect(patch: '/leads/1').not_to be_routable
      expect(delete: '/leads/1').not_to be_routable
    end
  end

  context "sessions controller" do
    specify "get /signin to sessions#new" do
      expect(get: "/signin").to route_to(controller: "sessions", action: "new")
    end

    specify "post /signin to sessions#create" do
      expect(post: "/signin").to route_to(controller: "sessions", action: "create")
    end

    specify "get /signout to sessions#destroy" do
      expect(get: "/signout").to route_to(controller: "sessions", action: "destroy")
    end

  end
end