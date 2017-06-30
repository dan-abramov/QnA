class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.id == @attachment.attachable.user_id
      @attachment.destroy
      # head :ok
    else
      flash[:notice] = 'You can not delete this attachment'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
