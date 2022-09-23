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
        @sub = Post.find_by(id: params[:id])
        render :edit
    end

    def update
        @sub = Post.find_by(id: params[:id])
        if @sub && @sub.update(sub_params)
            redirect_to sub_url(@sub.id)
        else
            flash.now[:errors] = @sub.errors.full_messages
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
    def sub_params
        params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
    end
end
