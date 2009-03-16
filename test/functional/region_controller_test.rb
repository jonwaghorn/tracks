require File.dirname(__FILE__) + '/../test_helper'
require 'region_controller'

# Re-raise errors caught by the controller.
class RegionController; def rescue_action(e) raise e end; end

class RegionControllerTest < Test::Unit::TestCase
  fixtures :regions

  def setup
    @controller = RegionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = regions(:first).id
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

    assert_not_nil assigns(:regions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:region)
    assert assigns(:region).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:region)
  end

  def test_create
    num_regions = Region.count

    post :create, :region => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_regions + 1, Region.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:region)
    assert assigns(:region).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Region.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Region.find(@first_id)
    }
  end
end
