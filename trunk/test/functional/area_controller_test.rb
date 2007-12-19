require File.dirname(__FILE__) + '/../test_helper'
require 'area_controller'

# Re-raise errors caught by the controller.
class AreaController; def rescue_action(e) raise e end; end

class AreaControllerTest < Test::Unit::TestCase
  fixtures :areas

  def setup
    @controller = AreaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = areas(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:areas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:area)
    assert assigns(:area).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:area)
  end

  def test_create
    num_areas = Area.count

    post :create, :area => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_areas + 1, Area.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:area)
    assert assigns(:area).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Area.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Area.find(@first_id)
    }
  end
end
