module BankTrain
  class LevelsController < BankTrain::ApplicationController
    def index
      @levels = BankTrain::Level.all
    end

    def new
      @level = Level.new
      form_html = render_to_string :partial => "new"
      render :json => {
        :title => "创建级别",
        :body => form_html
      }
    end

    def create
      @level = Level.create(level_params)
      if @level.save
        form_html = render_to_string :partial => "level_index_tr", locals: {level: @level}
        render :json => {
          :status => 200,
          :body => form_html
        }
      else
        render :json => @level.errors.messages, :status => 413
      end
    end

    def edit
      @level = Level.find(params[:id])
      form_html = render_to_string :partial => "edit"
      render :json => {
        :title => "级别信息修改",
        :body => form_html
      }
    end

    def update
      @level = Level.find(params[:id])
      if @level.update_attributes(level_params)
        form_html = render_to_string :partial => "level_index_tr", locals:{ level: @level }
        render :json => {
          :status => 200,
          :body => form_html
        }
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