# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :a_user, class_name: 'User', foreign_key: 'A_user_id'
  belongs_to :b_user, class_name: 'User', foreign_key: 'B_user_id'
end
