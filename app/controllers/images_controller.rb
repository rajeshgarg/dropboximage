class ImagesController < ApplicationController
  
  before_action :set_Image, only: [:show, :edit, :update, :destroy]
  
  respond_to :html
  
  # 404
  rescue_from ActiveRecord::RecordNotFound do |exception| 
    rescue_record_not_found(exception)
  end

  # GET /Images
  # GET /Images.json
  def index
    @images = Image.all
    @json = @images.to_gmaps4rails do |image, marker|
      @image = image
      marker.infowindow render_to_string(:action => 'show', :layout => false)    
      marker.json({ :id => @image.id })
    end
  end

  def search
    if (!params[:lan].blank? || !params[:lat].blank?)
      @images = Image.near([params[:lat], params[:lan]],2)
      Rails.logger.info "lat, and lan"
    end
    unless params[:name].blank?
      @images =  @images.where(name:params[:name]) rescue  Image.where(name:params[:name])
      Rails.logger.info "name"
    end
    if (params[:lan].blank? && params[:lat].blank? && params[:name].blank?)
      @images = Image.all
    end
    @json = @images.to_gmaps4rails do |image, marker|
      @image = image
      marker.infowindow render_to_string(:action => 'show', :layout => false)    
      marker.json({ :id => @image.id })
    end
    render :action => :index
  end

  # GET /Images/1
  # GET /Images/1.json
  def show
    @image = Image.find(params[:id])
    respond_with(@image, :layout =>  !request.xhr?)
  end

  # GET /Images/new
  def new
    @image = Image.new(params[:image].present? ? image_params : nil)
    respond_with(@image, :layout => !request.xhr?)
  end

  # GET /Images/1/edit
  def edit
    @image = Image.find(params[:id])
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # POST /Images
  # POST /Images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_path, notice: 'Image was successfully created.' }
        format.js {}
      else
        format.html { render action: 'new' }
        format.js {}      
      end
    end
  end

  # PATCH/PUT /Images/1
  # PATCH/PUT /Images/1.json
  def update
    @image = Image.find(params[:id])
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to images_url, notice: 'Image was successfully updated.' }
        format.js {}  
      else
        format.html { render action: 'edit' }
        format.js {}  
      end
    end
  end

  # DELETE /Images/1
  # DELETE /Images/1.json
  def destroy
    @image = Image.find(params[:id])

    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.js {}  
    end
  end


private
  # Use callbacks to share common setup or constraints between actions.
  def set_Image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:picture,:name, :sport, :latitude, :longitude, :street_number, :route, :city, :country, :postal_code)
  end
  
  # Generic not found action
  def rescue_record_not_found(exception)
    respond_to do |format|
      format.html
      format.js { render :template => "Images/404.js.erb", :locals => {:exception => exception} }
    end
  end
end
