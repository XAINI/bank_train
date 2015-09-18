module BankTrain
  class PostsController < BankTrain::ApplicationController
    def index
      @posts = BankTrain::Post.all
    end

    def new
      @post = Post.new
      form_html = render_to_string :partial => "new"
      render :json => {
        :title => "创建岗位",
        :body => form_html
      }
    end

    def create
      @post = Post.create(post_params)
      if @post.save
        form_html = render_to_string :partial => 'post_index_data',locals: { post: @post } 
        render :json => {
          :status => 200,
          :body => form_html
        }
      else
        render :json => @post.errors.messages, :status => 413
      end
    end

    def edit
      @post = Post.find(params[:id])
      form_html = render_to_string :partial => "edit"
      render :json => {
        :title => "岗位信息修改",
        :body => form_html
      }
    end

    def update
      @post = Post.find(params[:id])
      if @post.update_attributes(post_params)
        form_html = render_to_string :partial => "post_index_data", locals: { post: @post }
        render :json => {
          :status => 200,
          :body => form_html
        }
      else
        render :json => @post.errors.messages, :status => 413
      end
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
