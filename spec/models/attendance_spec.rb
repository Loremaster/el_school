# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Attendance do
  pending "add some examples to (or delete) #{__FILE__}"
end
