class CreateTeacherEducations < ActiveRecord::Migration
  def change
    create_table :teacher_educations do |t|
      t.integer :user_id
      t.string  :teacher_education_university
      t.date    :teacher_education_year
      t.string  :teacher_education_graduation
      t.string  :teacher_education_speciality
      t.timestamps
    end
  end
end
