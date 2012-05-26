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

  # Nominal for lesson of pupil.
  def nominals_of_pupil_from_lesson( lesson, pupil_id  )
    estimations = lesson.reporting.estimations
    pupil_est = estimations.where( "pupil_id = ?", pupil_id ).first

    unless pupil_est.nil?
      pupil_est.nominal
    else
      ""
    end
  end

  # Number of visited lesons of subject by pupil.
  def number_of_visited_lessons( pupil, subject )
    curriculums = subject.qualifications.collect{ |q| q.curriculums }.flatten

    unless curriculums.empty?
      timetables = curriculums.collect{ |c| c.timetables }.flatten

      unless timetables.empty?
        lessons_ids = timetables.collect{ |t| t.lessons }.flatten.collect{ |l| l.id }
      else
        lessons_ids = []
      end
    else
      lessons_ids = []
    end

    pupil.attendances.where( :lesson_id => lessons_ids, :visited => true ).size           # Collecting attendances for subject which pupil VISITED!
  end

  # Average estimation of pupil's lesson.
  def average_estimation_for_pupil_lesson( pupil, subject )
    curriculums = subject.qualifications.collect{ |q| q.curriculums }.flatten

    unless curriculums.empty?
      timetables = curriculums.collect{ |c| c.timetables }.flatten

      unless timetables.empty?
        lessons = timetables.collect{ |t| t.lessons }.flatten

        unless lessons.empty?
          reportings_ids = lessons.collect{ |l| l.reporting.id }
        else
          reportings_ids = []
        end
      else
        reportings_ids = []
      end
    else
      reportings_ids = []
    end

    pupil.estimations.where(:reporting_id => reportings_ids).average( :nominal ).to_f       # Average of estimations for subject of pupil
  end
end
