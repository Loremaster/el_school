# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  user_login :string(255)
#  user_role  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :user_login, :user_role                                     #ALL users can set these.

  validates :user_login, :presence => true,
                         :length   => { :maximum => 50 },
                         :uniqueness => true                                  #Warning! It doesn't guarantee that field ll be unique! Tho connection in same time still can create same data!

  validates :user_role, :presence => true,
                        :inclusion => { :in => %w(admin teacher pupil class_head school_head) }

end
