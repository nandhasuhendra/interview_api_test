# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class UserValidationTest < ActiveSupport::TestCase
  test "should not save user without name" do
    user = build(:user, name: nil)
    assert_not user.save, "Saved the user without a name"
  end

  test "should not save user without email" do
    user = build(:user, email: nil)
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user without phone" do
    user = build(:user, phone: nil)
    assert_not user.save, "Saved the user without a phone"
  end

  test "should not save user with invalid email" do
    user = build(:user, email: "invalid_email")
    assert_not user.save, "Saved the user with an invalid email"
  end

  test "should save user with valid attributes" do
    user = build(:user)
    assert user.save, "Failed to save the user with valid attributes"
  end

  test "should not save user with duplicate email" do
    create(:user)
    user = build(:user)
    assert_not user.save, "Saved the user with a duplicate email"
  end
end
