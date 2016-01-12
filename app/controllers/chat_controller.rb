class ChatController < ApplicationController
  
  before_action :detect_devise_variant

  layout :detect_devise


  def index
    gid = params[:id]
    if Topic.exists?(:key => "#{gid}") and $redistopic.exists(gid)
      session[:group_id] = gid
      @title = $redistopic.hget(gid,"title")
      @visitor = $visitor.scard(gid) + 1
      talks = $rediscont.lrange gid, 0,-1
      cont = []
      num = 0
      talks.each do |content|
        msg = ActiveSupport::HashWithIndifferentAccess.new(eval(content))
        cont[num] = msg
        num = num + 1
      end

      gon.list = cont
    else 
      render :text => "そんなのないよ", :status => 404
    end
  end
  
  def main
    
  end


  private 
    def detect_devise_variant
      
      case request.user_agent
        when /iPhone/ 
          request.variant = :mobile
        when /Android/
          request.variant = :mobile
      end

    end

    
    def detect_devise
      
      case request.user_agent
        when /iPhone/ 
          return "mobile"
        when /Android/
          return "mobile"
      end

    end

end
