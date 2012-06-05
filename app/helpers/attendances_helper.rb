module AttendancesHelper
  def attendance_of_lesson_for_pupil_exists?( pupil_id, lesson_id )
    not Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.nil?
  end

  def attendance_id_of_lesson_for_pupil( pupil_id, lesson_id )
    Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.id
  end

  def color_of_attendance( pupil_id, lesson_id )
    return nil if Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.nil?

    if Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.visited
      "visited"
    else
      "unvisited"
    end
  end
end
