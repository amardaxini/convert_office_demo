class AssetsController < ApplicationController
  # GET /assets
  # GET /assets.xml
  before_filter :load_user
  def index
    @assets = @user.assets

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = @user.assets.find(params[:id])
    @valid_formats = @asset.list_valid_formats
    @asset_documents = @asset.asset_documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset =@user.assets.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = @user.assets.find(params[:id])
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset = @user.assets.new(params[:asset])
    respond_to do |format|
      if @asset.save
        format.html { redirect_to(@asset, :notice => 'Asset was successfully created.') }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = @user.assets.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html { redirect_to(@asset, :notice => 'Asset was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = @user.assets.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to assets_url }
      format.xml  { head :ok }
    end
  end

  def convert_document

    @asset = @user.assets.find(params[:id])
    file_name,path = @asset.start_conversion(params[:valid_format])
    @asset.asset_documents.create(:name=>file_name,:path=>path)
    respond_to do |format|
      format.html { redirect_to(@asset, :notice => 'Document was successfully converted.') }
    end
  end

  def download_document
    @asset = @user.assets.find(params[:id])
    @asset_document = @asset.asset_documents.find(params[:asset_document_id])
    if !@asset_document.blank?
      send_file("#{Rails.root}/public#{@asset_document.path}")
    end
  end
  def delete_document
    @asset = @user.assets.find(params[:id])
    @asset_document = @asset.asset_documents.find(params[:asset_document_id])
    if !@asset_document.blank?
      @asset_document.destroy
    end
    respond_to do |format|
      format.html { redirect_to(@asset,:notice => "Document is successfully deleted") }

    end
  end
  private
  def load_user
    @user = current_user
  end
end
