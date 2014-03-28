class LeadsController < ApplicationController

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    if @lead.save
      redirect_to thank_you_path(ref: @lead)
    else
      render :new
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :email)
  end
end
