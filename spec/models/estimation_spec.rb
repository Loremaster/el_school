# == Schema Information
#
# Table name: estimations
#
#  id           :integer         not null, primary key
#  reporting_id :integer
#  pupil_id     :integer
#  nominal      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Estimation do
  pending "add some examples to (or delete) #{__FILE__}"
end
