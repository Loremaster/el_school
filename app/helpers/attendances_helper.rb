module AttendancesHelper
  def attendance_of_lesson_for_pupil_exists?( pupil_id, lesson_id )
    not Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.nil?
  end

  def attendance_id_of_lesson_for_pupil( pupil_id, lesson_id )
    Attendance.where("pupil_id = ? AND lesson_id = ?",pupil_id, lesson_id).first.id
  end
end
