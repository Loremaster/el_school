# encoding: UTF-8
module HomeworksHelper
  # => lesson_date - day - number_of_lesson
  def homework_lesson_info( homework )
    "#{homework.lesson.lesson_date.strftime("%d.%m.%Y")} - " +
    "#{translate_day_of_week(homework.lesson.timetable.tt_day_of_week)} - " +
    "#{homework.lesson.timetable.tt_number_of_lesson}й урок"
  end
end
