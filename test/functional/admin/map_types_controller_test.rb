require 'test_helper'

class Admin::MapTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_map_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_map_type
    assert_difference('MapType.count') do
      post :create, :map_type => { }
    end

    assert_redirected_to map_type_path(assigns(:map_type))
  end

  def test_should_show_map_type
    get :show, :id => admin_map_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_map_types(:one).id
    assert_response :success
  end

  def test_should_update_map_type
    put :update, :id => admin_map_types(:one).id, :map_type => { }
    assert_redirected_to map_type_path(assigns(:map_type))
  end

  def test_should_destroy_map_type
    assert_difference('MapType.count', -1) do
      delete :destroy, :id => admin_map_types(:one).id
    end

    assert_redirected_to admin_map_types_path
  end
end
