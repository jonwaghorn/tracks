require File.dirname(__FILE__) + '/../test_helper'
require 'track_connections_controller'

# Re-raise errors caught by the controller.
class TrackConnectionsController; def rescue_action(e) raise e end; end

class TrackConnectionsControllerTest < Test::Unit::TestCase
  fixtures :track_connections

  def setup
    @controller = TrackConnectionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = track_connections(:first).id
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

    assert_not_nil assigns(:track_connections)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:track_connection)
    assert assigns(:track_connection).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:track_connection)
  end

  def test_create
    num_track_connections = TrackConnection.count

    post :create, :track_connection => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_track_connections + 1, TrackConnection.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:track_connection)
    assert assigns(:track_connection).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TrackConnection.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TrackConnection.find(@first_id)
    }
  end
end
