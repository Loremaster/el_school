# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: parent_pupils
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ParentPupil < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :parent
end
