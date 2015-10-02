class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :search, :tag]
  before_action :check_user, except: [:index, :show, :search, :tag]

  # GET /products
  # GET /products.json
  def index
    @new_products = Product.all.order('created_at DESC').limit(3)
    @trending_products = Product.all.order('created_at ASC').limit(3)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @review = Review.new
    @reviews = Review.where(product_id: @product.id).order('created_at DESC')
    @tags = @product.tag_list
    @similar_products = @product.find_related_tags
    if @reviews.blank?
      @ease_rating = 0
      @speed_rating = 0
      @avg_rating = 0
    else
      @ease_rating = @reviews.average(:ease_of_use_rating).round(2)
      @speed_rating = @reviews.average(:speed_of_dev_rating).round(2)
      @avg_rating = @reviews.average(:rating).round(2)
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    product_params['tag_list'] = format_tags(product_params['tag_list'])
    fail
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def search
    if params[:search].present?
      @products = Product.search(params[:search], fields: [{name: :word_start}])
    else
      @products = Product.all
    end
  end

  def tag
    if params[:tag].present?
      @tag = CGI.unescape(params[:tag])
      @products = Product.tagged_with(@tag)
    else
      @tag = nil
      @product = Product.new
    end
  end

  private

    def check_user
      unless current_user.admin?
        redirect_to root_url, alert: 'Sorry, only admins can do that!'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def format_tags(tag_list)
      results = tag_list.split(/,/)
      return results.map {|result| result.strip }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :website, :description, :image, :tag_list)
    end
end
