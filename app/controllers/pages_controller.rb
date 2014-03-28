class PagesController < ApplicationController

  def thank_you
    if params[:ref].present?
      @lead = Lead.find(params[:ref])
    end
  end
end