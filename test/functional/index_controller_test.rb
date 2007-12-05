require File.dirname(__FILE__) + '/../test_helper'
require 'index_controller'

# Re-raise errors caught by the controller.
class IndexController; def rescue_action(e) raise e end; end

class IndexControllerTest < Test::Unit::TestCase
  fixtures :specials

  def setup
    @controller = IndexController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = specials(:first).id
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

    assert_not_nil assigns(:specials)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:special)
    assert assigns(:special).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:special)
  end

  def test_create
    num_specials = Special.count

    post :create, :special => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_specials + 1, Special.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:special)
    assert assigns(:special).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Special.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Special.find(@first_id)
    }
  end
end
