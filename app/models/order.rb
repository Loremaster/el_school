# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  pupil_id        :integer
#  school_class_id :integer
#  number_of_order :string(255)
#  date_of_order   :date
#  text_of_order   :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Order < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :school_class
end
