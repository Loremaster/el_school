# == Schema Information
#
# Table name: parent_meetings
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  meeting_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ParentMeeting < ActiveRecord::Base
  belongs_to :parent
  belongs_to :meeting
end
