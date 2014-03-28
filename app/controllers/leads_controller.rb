class LeadsController < ApplicationController

  def new
    @lead = Lead.new
  end
end
