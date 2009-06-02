class AdminController < ApplicationController

  layout 'shared'

  before_filter :admin_required
  before_filter :set_title

  def index
  end

  def set_title
    @title = 'ADMIN'
  end
end
