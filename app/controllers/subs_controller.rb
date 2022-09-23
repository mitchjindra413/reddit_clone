class SubsController < ApplicationController
    before_action :require_login, except: [:index, :show]
    before_action :is_moderator?, only: [:edit, :update]

    def new
        @sub = Sub.new
        render :new
    end

    def create
        @sub = Sub.new(sub_params)
        if @sub && @sub.save
            redirect_to sub_url(@sub.id)
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    def index
        @subs = Sub.all
        render :index
    end

    def show
        @sub = Sub.find_by(id: params[:id])
        render :show
    end

    def edit
        @sub = Sub.find_by(id: params[:id])
        render :edit
    end

    def update
        @sub = Sub.find_by(id: params[:id])
        if @sub && @sub.update(sub_params)
            redirect_to sub_url(@sub.id)
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :edit
        end
    end

    def is_moderator?
        if @sub.moderator_id != current_user.id
            flash.now[:errors] = ["Can't edit someone elses sub!"]
            render :index
        end
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description, :moderator)
    end

end
