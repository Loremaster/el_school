# Using Factory girl gem.
FactoryGirl.define do
  factory :user do |user|
    # user.user_login "Another User"
    user.user_role "admin"
    user.password "foobar"
    user.sequence(:user_login) { |n| "person=#{n}" }
  end

  sequence :user_login do |n|
    "person-#{n}"
  end

  factory :teacher do |teacher|
    teacher.teacher_last_name   'Bokov'
    teacher.teacher_first_name  'Vladimir'
    teacher.teacher_middle_name 'Nikolaivich'
    teacher.teacher_birthday    '01.11.1980'
    teacher.teacher_category    'First category'
    teacher.teacher_sex         'm'
    teacher.user                                                                            # That means that teacher belongs to user.
  end

  factory :subject do |subject|
    subject.subject_name 'Math'
  end 

  factory :teacher_leader do |tl|
    tl.user
    tl.teacher
  end

  factory :school_class do |c|
    c.date_of_class_creation "#{Date.today}"
    c.class_code '11v'
    c.teacher_leader
  end   

  factory :pupil do |p|
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

  factory :pupil_phone do |pp|
    pp.pupil_home_number   '123456'   
    pp.pupil_mobile_number '65454343'
    pp.pupil
  end
  
  factory :order do |o|
    o.number_of_order '1234'
    o.date_of_order "#{Date.today}"
    o.text_of_order 'Some text here.'
    o.pupil
    o.school_class
  end
end


