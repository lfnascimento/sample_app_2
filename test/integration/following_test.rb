require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:luis)
    @other_user = users(:joao)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow a user stantard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other_user.id
    end
  end

  test "should unfollow a user stantard way" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other_user.id
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end

end