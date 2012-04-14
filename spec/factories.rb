# Using Factory girl gem.
Factory.define :user do |user|
  # user.user_login "Another User"
  user.user_role "admin"
  user.password "foobar"
  user.sequence(:user_login) { |n| "person=#{n}" }
end

Factory.sequence :user_login do |n|
  "person-#{n}"
end

Factory.define :teacher do |teacher|
  teacher.teacher_last_name   'Bokov'
  teacher.teacher_first_name  'Vladimir'
  teacher.teacher_middle_name 'Nikolaivich'
  teacher.teacher_birthday    '01.11.1980'
  teacher.teacher_category    'First category'
  teacher.teacher_sex         'm'
  teacher.user                                                                            # That means that teacher belongs to user.
end

Factory.define :subject do |subject|
  subject.subject_name 'Math'
end 

Factory.define :teacher_leader do |tl|
  tl.user
  tl.teacher
end

Factory.define :school_class do |c|
  c.date_of_class_creation "#{Date.today}"
  c.class_code '11v'
  c.teacher_leader
end   

Factory.define :pupil do |p|
  p.pupil_last_name 'Kopov'
  p.pupil_first_name 'Valeriy'
  p.pupil_middle_name 'Olegovich'
  p.pupil_birthday "#{Date.today - 10.years}"
  p.pupil_sex 'm'
  p.pupil_nationality 'Russian'
  p.pupil_address_of_registration "Moscow"
  p.pupil_address_of_living "Moscow"
  p.user
  p.school_class
end

# Factory.define :teacher_phone do |tp|
#   tp.teacher_home_number '8-499-111-11-11'
#   tp.teacher_mobile_number '8-999-555-44-33'
#   tp.teacher
# end


