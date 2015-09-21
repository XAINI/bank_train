module BankTrain
  class BusinessOperationsController < BankTrain::ApplicationController
    def index
      return if params[:format] != "json"

      if params[:filter].blank?
        @operations = BankTrain::BusinessOperation.all
      else
        @operations = BankTrain::BusinessOperation.where(id: params[:filter]).first.descendants_and_self
      end
      render :json => @operations.map(&:to_hash)
    end

    def new
      @operation = BusinessOperation.new
    end

    def create
      @operation = BusinessOperation.new(bussiness_operations_params)
      if @operation.save
        redirect_to  '/business_operations'
      else
        render "new"
      end
    end

    def edit
      @operation = BusinessOperation.find(params[:id])
    end

    def update
      @operation = BusinessOperation.find(params[:id])
      if @operation.update_attributes(bussiness_operations_params)
        redirect_to "/business_operations"
      else
        render "edit"
      end
    end

    def destroy
      @operation = BusinessOperation.find(params[:id])
      @operation.destroy
      redirect_to "/business_operations"
    end

    private

      def bussiness_operations_params
        params.require(:business_operation).permit(:number, :name, :chapter_number, :parent_id,:business_category_ids=>[])
      end
  end
end
