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

  # Translate to Russian sex.
  def translate_sex( sex )
    sexes = { "m" => "Мужской", "w" => "Женский" }
    sexes[ sex ]
  end

  # We use that in date select.
  def russian_names_of_months
    ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября",
     "Октября", "Ноября", "Декабря"]
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

  # Return 1 curriculum for teacher.
  # => <#Curriculum> - if curriculum founded
  # => nil - if we didn't find curriculum
  def curriculum_for_teacher_with_subject_and_class( teacher, subject_name, school_class )
    subject = teacher.subjects.where(:subject_name => subject_name).first                 # Get subject for teacher.
    subject_qualification = teacher.qualifications.where(:subject_id => subject.id).first # Qualification for subject.
    curriculum = subject_qualification.curriculums.select do |c|                          # Filter curriculum
      c.school_class.class_code == school_class.class_code                                # ... via input class code
    end

    unless curriculum.empty?                                                              # If we found curriculum return it (first element in array)
      curriculum.first
    else
      nil                                                                                 # Then return nil, it will help to debug (i hope)
    end
  end

  # Pupil results for subject in school class.
  def pupil_results( pupil, teacher, subject_name, school_class )
    curriculum = curriculum_for_teacher_with_subject_and_class( teacher, subject_name,
                                                                school_class )
    if not curriculum.nil? and not pupil.nil?
      pupil.results.where(:curriculum_id => curriculum.id).first                          # Find results of pupil for chosen subject and class code.
    else
      nil
    end
  end

  # Get qualification for input teacher and subject
  # => nil if qualification have not been founded.
  def qualification_for_teacher_with_subject( teacher, subject )
    teacher.qualifications.where(:subject_id => subject.id).first                         # Qualification for subject.
  end

  # Get curriculum for qualification teacher and school_class
  # => nil if curriculum have not been founded.
  def curriculum_for_qualification_with_school_class( qualification, school_class )
    qualification.curriculums.where(:school_class_id => school_class.id).first
  end

  def date_year_from_now( num_years=18 )
    (Date.today - num_years.years).year.to_i
  end

  def date_year_in_future_from_now( num_years=18 )
    (Date.today + num_years.years).year.to_i
  end
end
