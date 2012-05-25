# encoding: UTF-8
module JournalsHelper

  # Return correct name of lesson for journal.
  def correct_lesson_name( lesson )
    type = lesson.reporting.report_type
    out_date = lesson.lesson_date.strftime("%d.%m.%Y")

    case type
      when "intermediate_result"
        "Промежуточная отчетность (#{out_date})"
      when "year_result"
        "Итоговая (#{out_date})"
      else                                                                                # All other types.
        out_date                                                                          # Return date of chosen format.
    end
  end
end
