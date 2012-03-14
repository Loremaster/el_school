module ApplicationHelper

  #Use this to highlight active page's (toolbar).
  def active_toolbar? ( path )
    if current_page?( path )
      "active"
    else
      ""
    end
  end

  # def get_errors ( user )    
  #   user.errors.full_messages.each { |e|  }
  # end
end
