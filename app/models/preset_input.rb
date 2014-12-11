class PresetInput < ActiveRecord::Base
  has_one :desired_output
  belongs_to :net
end
