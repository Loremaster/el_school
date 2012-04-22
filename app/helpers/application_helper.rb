module ApplicationHelper

  # Use this to highlight active page's (toolbar).
  def active_toolbar? ( path )
    if current_page?( path )
      "active"
    else
      ""
    end
  end

  # Teacher full names: last + first + middle. 
  def teacher_full_names( teacher )
    "#{teacher.teacher_last_name} #{teacher.teacher_first_name} #{teacher.teacher_middle_name}"
  end
  
  def pupil_full_names( pupil )
    "#{pupil.pupil_last_name} #{pupil.pupil_first_name} #{pupil.pupil_middle_name}"
  end
end
