module ApplicationHelper

  def active_toolbar? ( path )
    if current_page?( path )
      "active"
    else
      ""
    end
  end

end
