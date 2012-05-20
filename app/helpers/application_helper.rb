# encoding: UTF-8
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

  # Pupil full names: last + first + middle.
  def pupil_full_names( pupil )
    "#{pupil.pupil_last_name} #{pupil.pupil_first_name} #{pupil.pupil_middle_name}"
  end

  def parent_full_names( parent  )
    "#{parent.parent_last_name} #{parent.parent_first_name} #{parent.parent_middle_name}"
  end

  # User role to russian word.
  def translate_user_role( role )
    roles = { :admin => "Администратор", :teacher => "Учитель", :pupil => "Ученик",
              :class_head => "Классный руководитель", :school_head => "Завуч",
              :parent => "Родитель" }
    roles[ role.to_sym ]
  end

  # Day of week to russian word.
  def translate_day_of_week( day )
    days = { :Mon => "Понедельник", :Tue => "Вторник", :Wed => "Среда", :Thu => "Четверг",
             :Fri => "Пятница" }
    days[ day.to_sym ]
  end

  # Type of lessong to russian word.
  def translate_type_of_lesson( lesson )
    lessons = { "Primary lesson" => "Обязательное занятие", "Extra" => "Электив" }
    lessons[ lesson ]
  end

  def attendance_of_lesson_for_pupil_exists?( pupil_id, lesson_id )
    not Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.nil?
  end
end
