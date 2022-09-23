class PostsController < ApplicationController
    before_action :require_login, except: [:show]
    before_action :is_poster?, only: [:edit, :update]

    def new
        @post = Post.new
        render :new
    end

    def create
        @post = Post.new(post_params)
        if @post && @post.save
            redirect_to post_url(@post.id)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end

    def show
        @post = Post.find_by(id: params[:id])
        render :show
    end

    def edit
        @post = Post.find_by(id: params[:id])
        render :edit
    end

    def update
        @post = Post.find_by(id: params[:id])
        if @post && @post.update(post_params)
            redirect_to sub_url(@post.id)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :edit
        end
    end

    def is_poster?
        if @post.author_id != current_user.id
            flash.now[:errors] = ["Can't edit someone else's post!"]
            render :index
        end
    end

    private
    def post_params
        params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
    end
end
