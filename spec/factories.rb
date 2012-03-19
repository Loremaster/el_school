#Using Factory girl gem.
Factory.define :user do |user|
  user.user_login "Another User"
  user.user_role "admin"
  user.password "foobar"
end

Factory.sequence :user_login do |n|
  "person-#{n}"
end

# Factory.define :teacher do |teacher|
#   teacher.teacher_surname     'Bokov'
#   teacher.teacher_name        'Vladimir'
#   teacher.teacher_middle_name 'Nikolaivich'
#   teacher.teacher_birth       '01.11.1980'
#   teacher.teacher_category    'First category'
#   teacher.teacher_sex         'm'
# end
#
#Factory.sequence :user_role do |n|
#  "Person #{n}"
#end

