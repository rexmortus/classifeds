require 'test_helper'

class UserTest < ActiveSupport::TestCase


  test "test if private key is automatically generated" do
    # 1. setup
    puts "creating a user"
      user = User.new(
        email: 'admin@classifeds.aus.party',
        username: 'admin',
        password: 'topsecret',
        password_confirmation: 'topsecret',
        location: 'Melbourne, Australia'
      )

    # 2. excersize

    puts "Assert that privatekey is nil"
    assert_not user.privkey

    puts "Save the user"
    user.save

    puts "Assert that user has a private key"
    assert_not_nil user.privkey

    # 3. validation
    # 3. Teardown
    user.destroy!

  end


end





























# test "the truth" do
#
#   user = User.new(
#     email: 'admin@classifeds.aus.party',
#     username: 'admin',
#     password: 'topsecret',
#     password_confirmation: 'topsecret',
#     location: 'Melbourne, Australia')
#
#   assert_nil user.actor
#   user.save
#
#   assert_equal 'admin@classifeds.aus.party', user.email
#   assert_not_nil user.actor
# end
