require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::MessagesController < ApplicationController

    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin
    
    def new
      @message = Message.new
    end

    def create
      @message      = MessageComposer.compose(message_params.except(:conversation_id))
      @conversation = find_conversation
      @message.conversation = @conversation

      if @message.save
        flash.notice = t('tincanz.messages.created')
        redirect_to admin_conversation_path(@message.conversation)
      else
        flash.alert  = t('tincanz.messages.not_created')
         render :new
      end
    end

    private

    def message_params
      params.require(:message).permit(:conversation_id, :user_id, :content)
    end

    def find_conversation
      @conversation = Conversation.where(id: message_params[:conversation_id]).first ||
                      Conversation.create(user: tincanz_user) 
    end
  end
end
