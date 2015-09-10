module BankTrain
  class LevelsController < BankTrain::ApplicationController
    def index
      @levels = BankTrain::Level.all
      @level = Level.new
    end

    def new
      @level = Level.new
    end

    def create
      @level = Level.create(level_params)
      if @level.save
        render :json => {:status => 200}
      else
        render :json => @level.errors.messages, :status => 413
      end
    end

    def edit
      @level = Level.find(params[:id])
      render "edit", layout: false
    end

    def update
      @level = Level.find(params[:id])
      if @level.update_attributes(level_params)
        render :json => {:status => 200}
      else
        render :json => @level.errors.messages, :status => 413
      end
    end

    def destroy
      @level = Level.find(params[:id])
      @level.destroy
      redirect_to "/levels"
    end

    private
      def level_params
        params.require(:level).permit(:number, :name, :post_ids => [])
      end
  end
end