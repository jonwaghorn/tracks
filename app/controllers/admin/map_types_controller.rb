class Admin::MapTypesController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @map_types = MapType.find(:all)
  end

  def show
    @map_type = MapType.find(params[:id])
  end

  # GET /admin_map_types/new
  # GET /admin_map_types/new.xml
  def new
    @map_type = MapType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @map_type }
    end
  end

  # GET /admin_map_types/1/edit
  def edit
    @map_type = MapType.find(params[:id])
  end

  # POST /admin_map_types
  # POST /admin_map_types.xml
  def create
    @map_type = MapType.new(params[:map_type])

    respond_to do |format|
      if @map_type.save
        flash[:notice] = 'MapType was successfully created.'
        format.html { redirect_to(@map_type) }
        format.xml  { render :xml => @map_type, :status => :created, :location => @map_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @map_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_map_types/1
  # PUT /admin_map_types/1.xml
  def update
    @map_type = MapType.find(params[:id])

    respond_to do |format|
      if @map_type.update_attributes(params[:map_type])
        flash[:notice] = 'MapType was successfully updated.'
        format.html { redirect_to(@map_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_map_types/1
  # DELETE /admin_map_types/1.xml
  def destroy
    @map_type = MapType.find(params[:id])
    @map_type.destroy

    respond_to do |format|
      format.html { redirect_to(admin_map_types_url) }
      format.xml  { head :ok }
    end
  end
end
