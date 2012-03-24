# Using Factory girl gem.
Factory.define :user do |user|
  user.user_login "Another User"
  user.user_role "admin"
  user.password "foobar"
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

# Factory.define :teacher_phone do |tp|
#   tp.teacher_home_number '8-499-111-11-11'
#   tp.teacher_mobile_number '8-999-555-44-33'
#   tp.teacher
# end


