require 'test_helper'

class MediasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:medias)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media
    assert_difference('Media.count') do
      post :create, :media => { }
    end

    assert_redirected_to media_path(assigns(:media))
  end

  def test_should_show_media
    get :show, :id => medias(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => medias(:one).id
    assert_response :success
  end

  def test_should_update_media
    put :update, :id => medias(:one).id, :media => { }
    assert_redirected_to media_path(assigns(:media))
  end

  def test_should_destroy_media
    assert_difference('Media.count', -1) do
      delete :destroy, :id => medias(:one).id
    end

    assert_redirected_to medias_path
  end
end
