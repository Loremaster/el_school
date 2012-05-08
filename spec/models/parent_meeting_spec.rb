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

require 'spec_helper'

describe ParentMeeting do
  pending "add some examples to (or delete) #{__FILE__}"
end
