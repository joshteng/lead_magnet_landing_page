module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | EbookLandingPage"      
    end
  end
end
