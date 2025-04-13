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

require "test_helper"

class JobTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test "should not save job without title" do
    job = Job.new(description: "Job description", status: "pending")
    assert_not job.save, "Saved the job without a title"
  end

  test "should not save job without description" do
    job = Job.new(title: "Job title", status: "pending")
    assert_not job.save, "Saved the job without a description"
  end

  test "should not save job without status" do
    job = Job.new(title: "Job title", description: "Job description")
    assert_not job.save, "Saved the job without a status"
  end

  test "should not save job with invalid status" do
    job = Job.new(title: "Job title", description: "Job description", status: "invalid_status")
    assert_not job.save, "Saved the job with an invalid status"
  end

  test "should save job with valid attributes with missing user" do
    job = Job.new(title: "Job title", description: "Job description", status: "pending")
    assert_not job.save, "Failed to save the job with valid attributes"
    assert_includes job.errors.full_messages, "User must exist", "Job should not be saved without a user"
  end

  test "should save job with valid attributes" do
    job = Job.new(title: "Job title", description: "Job description", status: "pending", user: @user)
    assert job.save, "Failed to save the job with valid attributes"
    assert_equal "Job title", job.title, "Job title is not saved correctly"
    assert_equal "Job description", job.description, "Job description is not saved correctly"
    assert_equal "pending", job.status, "Job status is not saved correctly"
    assert_equal @user, job.user, "Job user is not saved correctly"
  end
end
