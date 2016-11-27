class IndexController < ApplicationController
	layout false
	require 'net/http'
require 'json'
require 'uri'
  def index
  end

  def deletefiles
  	if dfiles_params[:password].to_i == 123
  		begin
	  		@token=dfiles_params[:token]
	  		@ts_to = (Time.now - dfiles_params[:date].to_i * 24 * 60 * 60).to_i
	  		@files=getfiles(@token,@ts_to)
	  		@file_ids = @files.map { |f| f['id'] }
	  	rescue
	  		flash[:notice]="Something isn't correct. Please make sure to entry all correct fields.Token might be worng"
      		redirect_to(:action=>'index')
	  	end
  	else
  	  flash[:notice]="Worng Password."
      redirect_to(:action=>'index')
  	end
  end


  private
  def getfiles(tokenp,ts_top)
  	@params = {
				    token: tokenp,
				    ts_to: ts_top,
				    count: 1000
				  }
		@uri = URI.parse('https://slack.com/api/files.list')
		@uri.query = URI.encode_www_form(@params)
		@response = Net::HTTP.get_response(@uri)
		JSON.parse(@response.body)['files']
  end
  def dfiles_params
      params.require(:deletefiles).permit(:token,:date,:password)
  end
end
