class StockManager::CategoriesController < StockManager::BaseController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  
  def index
    @categories = Category.all
    render partial: 'list', layout: false
  end
  
  def new
    @category = Category.new
    render partial: 'form', locals: { action: 'new' }, layout: false
  end
  
  def create
    @category = Category.new(category_params)
    
    if @category.save
      render json: { success: true, message: 'Category created successfully!', category: { id: @category.id, name: @category.name } }
    else
      render partial: 'form', locals: { action: 'new' }, status: :unprocessable_entity, layout: false
    end
  end
  
  def edit
    @category = Category.find(params[:id])
    render partial: 'form', locals: { action: 'edit' }, layout: false
  end
  
  def update
    @category = Category.find(params[:id])
    
    if @category.update(category_params)
      render json: { success: true, message: 'Category updated successfully!' }
    else
      render partial: 'form', locals: { action: 'edit' }, status: :unprocessable_entity, layout: false
    end
  end
  
  private
  
  def category_params
    params.require(:category).permit(:name)
  end
end