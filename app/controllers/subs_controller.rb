class SubsController < ApplicationController
    def new
        @sub = Sub.new
        render :new
    end

    def create
        @sub = Sub.new(sub_params)
        if @sub && @sub.save
            redirect_to sub_url(@sub.id)
            
        end
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description, :moderator)
    end

end
