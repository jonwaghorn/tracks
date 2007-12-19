require File.dirname(__FILE__) + '/../test_helper'
require 'state_controller'

# Re-raise errors caught by the controller.
class StateController; def rescue_action(e) raise e end; end

class StateControllerTest < Test::Unit::TestCase
  fixtures :states

  def setup
    @controller = StateController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = states(:first).id
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

    assert_not_nil assigns(:states)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:state)
  end

  def test_create
    num_states = State.count

    post :create, :state => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_states + 1, State.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      State.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      State.find(@first_id)
    }
  end
end
