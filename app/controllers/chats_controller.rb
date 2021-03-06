class ChatsController < ApplicationController
  def room
  	redirect_to login_user_path if current_user.nil?
  end

  def new_message
    # Check if the message is private
    if recipient = params[:message].match(/@(.+) (.+)/)
      # It is private, send it to the recipient's channel
      # message = {:username => session[:username], :msg => recipient.captures.second}.to_json
      # Net::HTTP.post_form(faye, :message => {:channel => "/messages/private/#{recipient.captures.first}", :data => message}.to_json)
      @channel = "/messages/private/#{recipient.captures.first}"
      @message = { :username => current_user.beamer_id, :msg => recipient.captures.second }
    else
      # message = {:username => session[:username], :msg => params[:message]}.to_json
      # Net::HTTP.post_form(faye, :message => {:channel => '/messages/public', :data => message}.to_json)
      @channel = "/messages/public"
      @message = { :username => "#{current_user.first_name}_#{current_user.beamer_id}", :msg => params[:message] }
    end
    
    respond_to do |f|
      f.js
    end
  end

  def index
    redirect_to login_user_path if current_user.nil?
    @chats = Chat.all
  end

  def create
    @chat = Chat.create!(params[:chat])  
  end
end
