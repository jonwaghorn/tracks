require File.dirname(__FILE__) + '/../test_helper'
require 'track_aka_controller'

# Re-raise errors caught by the controller.
class TrackAkaController; def rescue_action(e) raise e end; end

class TrackAkaControllerTest < Test::Unit::TestCase
  fixtures :track_akas

  def setup
    @controller = TrackAkaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = track_akas(:first).id
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

    assert_not_nil assigns(:track_akas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:track_aka)
    assert assigns(:track_aka).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:track_aka)
  end

  def test_create
    num_track_akas = TrackAka.count

    post :create, :track_aka => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_track_akas + 1, TrackAka.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:track_aka)
    assert assigns(:track_aka).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TrackAka.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TrackAka.find(@first_id)
    }
  end
end
