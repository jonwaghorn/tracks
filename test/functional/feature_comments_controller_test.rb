require 'test_helper'

class FeatureCommentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:feature_comments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_feature_comment
    assert_difference('FeatureComment.count') do
      post :create, :feature_comment => { }
    end

    assert_redirected_to feature_comment_path(assigns(:feature_comment))
  end

  def test_should_show_feature_comment
    get :show, :id => feature_comments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => feature_comments(:one).id
    assert_response :success
  end

  def test_should_update_feature_comment
    put :update, :id => feature_comments(:one).id, :feature_comment => { }
    assert_redirected_to feature_comment_path(assigns(:feature_comment))
  end

  def test_should_destroy_feature_comment
    assert_difference('FeatureComment.count', -1) do
      delete :destroy, :id => feature_comments(:one).id
    end

    assert_redirected_to feature_comments_path
  end
end
