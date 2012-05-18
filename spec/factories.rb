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
    teacher.teacher_phone
    teacher.teacher_education
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

  factory :teacher_phone do |tp|
    tp.teacher_home_number '13575432'
    tp.teacher_mobile_number '23456778'
  end

  factory :teacher_education do |te|
    te.teacher_education_university 'MIT'
    te.teacher_education_year       "#{Date.today - 10.years}"
    te.teacher_education_graduation 'Programmer'
    te.teacher_education_speciality 'Math programmer'
  end

  factory :order do |o|
    o.number_of_order '1234'
    o.date_of_order "#{Date.today}"
    o.text_of_order 'Some text here.'
    o.pupil
    o.school_class
  end

  factory :parent do |p|
    p.parent_last_name   'Skobkin'
    p.parent_first_name  'Serj'
    p.parent_middle_name 'Kopun'
    p.parent_birthday    "#{Date.today - 20.years}"
    p.parent_sex         'm'
    p.user
  end

  factory :parent_pupil do |pp|
    pp.parent
    pp.pupil
  end

  factory :meeting do |m|
    m.meeting_theme 'Some theme!'
    m.meeting_date  "#{Date.today}"
    m.meeting_time  '21:01'
    m.meeting_room  '123'
    m.school_class
  end

  factory :qualification do |q|
    q.teacher
    q.subject
  end

  factory :curriculum do |c|
    c.qualification
    c.school_class
  end

  factory :event do |e|
    e.school_class
    e.teacher
    e.event_place  "Piter"
    e.event_place_of_start  "Moscow"
    e.event_begin_date  "#{Date.today}"
    e.event_end_date  "#{Date.today}"
    e.event_begin_time  Time.now.strftime("%H:%M")
    e.event_end_time  Time.now.strftime("%H:%M")
    e.event_cost  "500"
  end

  factory :timetable do |t|
    t.curriculum
    t.school_class
    t.tt_day_of_week 'Mon'
    t.tt_number_of_lesson '1'
    t.tt_room '123'
    t.tt_type 'Primary lesson'
  end

  factory :lesson do |l|
    l.timetable
    l.lesson_date "#{Date.today.strftime("%d.%m.%Y")}"
  end


end


