#Using Factory girl gem.
Factory.define :user do |user|
  user.user_login "Another User"
  user.user_role "admin"
  user.password "foobar"
end

Factory.sequence :user_login do |n|
  "person-#{n}"
end
#
#Factory.sequence :user_role do |n|
#  "Person #{n}"
#end
