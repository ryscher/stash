require_dependency "stash_engine/application_controller"

module StashEngine
  class SharesController < ApplicationController
    before_action :set_share, only: [:edit, :update, :delete]

    # GET /shares/1/edit
    def edit
    end

    # POST /shares
    def create
      ## creates a new share object with resource_id as params
      @share = Share.new(resource_id: params[:resource_id])
      respond_to do |format|
        if @share.save
          format.js
        else
          render :new
        end
      end
    end

    # PATCH/PUT /shares/1
    def update
              byebug
      respond_to do |format|
        @share.expiration_date = @share.expiration_date + 30.days
        if @share.update(share_params)
          format.js
        else
          render :edit
        end
      end
    end

    # DELETE /shares/1
    def delete
      @share.destroy
      respond_to do |format|
        format.js
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_share
        @share = Share.find(share_params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def share_params
        params.require(:share).permit(:id, :sharing_link, :expiration_date, :resource_id)
      end
  end
end
