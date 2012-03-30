class Qualification < ActiveRecord::Base
  belongs_to :subject
  belongs_to :teacher
end
