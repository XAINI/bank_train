module BankTrain
  class PostsController < BankTrain::ApplicationController
    def index
      @posts = BankTrain::Post.all
      @post = Post.new
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.create(post_params)
      if @post.save
        render :json => {:status => 200}
      else
        render :json => @post.errors.messages, :status => 413
      end
    end

    def update
      @post = Post.find(params[:id])
      if @post.update_attributes(post_params)
        redirect_to "/posts"
      else
        render "edit"
      end
    end

    def edit
      @post = Post.find(params[:id])
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      redirect_to "/posts"
    end

    private
      def post_params
        params.require(:post).permit(:number, :name, :desc, :level_ids => [], :business_category_ids => [], :user_ids => [])
      end
  end
end
