# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  status      :string
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_jobs_on_user_id  (user_id)
#

class Job < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: ['pending', 'in_progress', 'completed'] }

  after_commit :refresh_cache

  def refresh_cache
    Rails.cache.delete("jobs_user_*")
    Rails.cache.delete("jobs_all")
  end
end
