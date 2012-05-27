# == Schema Information
#
# Table name: results
#
#  id            :integer         not null, primary key
#  pupil_id      :integer
#  curriculum_id :integer
#  quarter_1     :integer
#  quarter_2     :integer
#  quarter_3     :integer
#  quarter_4     :integer
#  year          :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Result < ActiveRecord::Base
end
