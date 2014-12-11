class DesiredOutput < ActiveRecord::Base
  belongs_to :preset_input
  belongs_to :net
end
