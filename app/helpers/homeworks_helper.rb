# encoding: UTF-8
module HomeworksHelper
  # => lesson_date - number_of_lesson
  def homework_lesson_info( homework )
    "#{homework.lesson.lesson_date.strftime("%d.%m.%Y")} - " +
    "#{homework.lesson.timetable.tt_number_of_lesson}й урок"
  end
end
