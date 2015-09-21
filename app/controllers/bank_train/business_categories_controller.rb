module BankTrain
  class BusinessCategoriesController < BankTrain::ApplicationController
    def index
      return if params[:format] != "json"

      @categories = BankTrain::BusinessCategory.all

      res = @categories.map do |category|
        oper_hash = category.business_operations.map do |oper|
          {
            :id   => oper.id.to_s,
            :name => oper.name
          }
        end

        {
          :id              => category.id.to_s,
          :parent_id       => category.parent_id.to_s,
          :name            => category.name,
          :children_info   => category.children.count == 0 ? "" : "[#{category.children.count} 项子业务种类]",
          :posts_info      => category.posts.count == 0 ? "" : "[#{category.posts.count} 个对应岗位]",
          :operations      => oper_hash
        }
      end

      render :json => res
    end

    def new
      @category = BankTrain::BusinessCategory.new
    end

    def create
      @category = BankTrain::BusinessCategory.new(business_category_params)
      if @category.save
        redirect_to "/business_categories"
      else
        render :new
      end
    end

    def edit
      @category = BankTrain::BusinessCategory.find(params[:id])
    end

    def update
      @category = BankTrain::BusinessCategory.find(params[:id])
      if @category.update(business_category_params)
        redirect_to "/business_categories"
      else
        render :edit
      end
    end

    def destroy
      @category = BankTrain::BusinessCategory.find(params[:id])
      @category.destroy
      redirect_to "/business_categories"
    end

    private
      def business_category_params
        params.require(:business_category).permit(:name, :parent_id, :post_ids => [], :business_operation_ids => [])
      end
  end
end
