# frozen_string_literal: true

class GroupTrack < ApplicationRecord
  belongs_to :group
  belongs_to :track
end
