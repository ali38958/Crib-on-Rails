class Admin::StocksController < Admin::BaseController
  def index
    @products = Product.includes(:category).all

    # Search filter
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @products = @products.where("name LIKE ?", search_term)
    end

    # Category filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Stock filter
    if params[:stock_filter].present?
      case params[:stock_filter]
      when 'low'
        @products = @products.where("quantity < 10 AND quantity > 0")
      when 'out'
        @products = @products.where(quantity: 0)
      when 'in'
        @products = @products.where("quantity >= 10")
      end
    end

    # Sort
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    @products = @products.order("#{sort_column} #{sort_direction}")

    # Pagination
    per_page = params[:per_page].to_i
    per_page = 100 if per_page > 100
    per_page = 10 if per_page < 1
    per_page = 10 if per_page.blank?

    @products = @products.page(params[:page]).per(per_page)
    @total_count = @products.total_count

    # Summary stats
    @total_products = Product.count
    @low_stock = Product.where("quantity < 10 AND quantity > 0").count
    @out_of_stock = Product.where(quantity: 0).count
    @total_value = Product.sum("quantity * current_price")

    # Chart data: Stock by Category
    @category_data = {
      labels: Category.pluck(:name),
      data: Category.joins(:products).group(:category_id).count.values
    }

    # Chart data: Stock Status
    @stock_status_data = {
      labels: ['In Stock', 'Low Stock', 'Out of Stock'],
      data: [
        Product.where("quantity >= 10").count,
        Product.where("quantity < 10 AND quantity > 0").count,
        Product.where(quantity: 0).count
      ]
    }

    @categories = Category.all.order(:name)
  end

  def export_csv
    @products = Product.includes(:category).all

    if params[:search].present?
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")
    end
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    send_data generate_csv(@products), filename: "stock_report_#{Date.today}.csv"
  end

  def export_pdf
    @products = Product.includes(:category).all
    # Apply filters
    if params[:search].present?
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")
    end
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "stock_report_#{Date.today}",
               template: "admin/stocks/export_pdf",
               layout: "pdf"
      end
    end
  end

  private

  def generate_csv(products)
    CSV.generate(headers: true) do |csv|
      csv << ["Product Name", "Category", "Quantity", "Price", "Total Value"]

      products.each do |product|
        csv << [
          product.name,
          product.category&.name || 'N/A',
          product.quantity,
          number_with_precision(product.current_price, precision: 2),
          number_with_precision(product.quantity * product.current_price, precision: 2)
        ]
      end
    end
  end
end