require File.dirname(__FILE__) + '/../test_helper'
require 'track_report_controller'

# Re-raise errors caught by the controller.
class TrackReportController; def rescue_action(e) raise e end; end

class TrackReportControllerTest < Test::Unit::TestCase
  fixtures :track_reports

  def setup
    @controller = TrackConditionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = track_reports(:first).id
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

    assert_not_nil assigns(:track_reports)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:track_report)
    assert assigns(:track_report).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:track_report)
  end

  def test_create
    num_track_reports = TrackReport.count

    post :create, :track_report => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_track_reports + 1, TrackReport.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:track_report)
    assert assigns(:track_report).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TrackReport.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TrackReport.find(@first_id)
    }
  end
end
