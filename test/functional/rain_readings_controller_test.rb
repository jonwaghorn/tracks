require File.dirname(__FILE__) + '/../test_helper'

class RainReadingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rain_readings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_rain_reading
    assert_difference('RainReading.count') do
      post :create, :rain_reading => { }
    end

    assert_redirected_to rain_reading_path(assigns(:rain_reading))
  end

  def test_should_show_rain_reading
    get :show, :id => rain_readings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => rain_readings(:one).id
    assert_response :success
  end

  def test_should_update_rain_reading
    put :update, :id => rain_readings(:one).id, :rain_reading => { }
    assert_redirected_to rain_reading_path(assigns(:rain_reading))
  end

  def test_should_destroy_rain_reading
    assert_difference('RainReading.count', -1) do
      delete :destroy, :id => rain_readings(:one).id
    end

    assert_redirected_to rain_readings_path
  end
end
