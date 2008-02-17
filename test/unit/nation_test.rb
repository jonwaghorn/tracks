require File.dirname(__FILE__) + '/../test_helper'

class NationTest < ActiveSupport::TestCase
  #fixtures :nations

  def test_invalid_with_empty_attributes
    nation = Nation.new
    assert !nation.valid?
    assert nation.errors.invalid?(:name)
    assert nation.errors.invalid?(:description)
#    assert nation.errors.invalid?(:date)
  end
end
