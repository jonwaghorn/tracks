require File.dirname(__FILE__) + '/../test_helper'
require 'condition_controller'

# Re-raise errors caught by the controller.
class ConditionController; def rescue_action(e) raise e end; end

class ConditionControllerTest < Test::Unit::TestCase
  fixtures :conditions

  def setup
    @controller = ConditionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = conditions(:first).id
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

    assert_not_nil assigns(:conditions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:condition)
    assert assigns(:condition).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:condition)
  end

  def test_create
    num_conditions = Condition.count

    post :create, :condition => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_conditions + 1, Condition.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:condition)
    assert assigns(:condition).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Condition.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Condition.find(@first_id)
    }
  end
end
