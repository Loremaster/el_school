# == Schema Information
#
# Table name: reportings
#
#  id           :integer         not null, primary key
#  report_type  :string(255)
#  report_topic :string(255)
#  lesson_id    :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Reporting do
  pending "add some examples to (or delete) #{__FILE__}"
end
