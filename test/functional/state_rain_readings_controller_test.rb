require File.dirname(__FILE__) + '/../test_helper'

class StateRainReadingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:state_rain_readings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_state_rain_reading
    assert_difference('StateRainReading.count') do
      post :create, :state_rain_reading => { }
    end

    assert_redirected_to state_rain_reading_path(assigns(:state_rain_reading))
  end

  def test_should_show_state_rain_reading
    get :show, :id => state_rain_readings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => state_rain_readings(:one).id
    assert_response :success
  end

  def test_should_update_state_rain_reading
    put :update, :id => state_rain_readings(:one).id, :state_rain_reading => { }
    assert_redirected_to state_rain_reading_path(assigns(:state_rain_reading))
  end

  def test_should_destroy_state_rain_reading
    assert_difference('StateRainReading.count', -1) do
      delete :destroy, :id => state_rain_readings(:one).id
    end

    assert_redirected_to state_rain_readings_path
  end
end
