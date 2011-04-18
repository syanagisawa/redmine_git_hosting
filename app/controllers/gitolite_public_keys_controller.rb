class GitolitePublicKeysController < ApplicationController
	unloadable
	
	before_filter :require_login
	before_filter :set_user_variable
	before_filter :find_gitolite_public_key, :except => [:index, :new, :create]

	#def index
	#	@status = if (session[:gitolite_public_key_filter_status]=params[:status]).nil?
	#		GitolitePublicKey::STATUS_ACTIVE
	#	elsif params[:status].blank?
	#			nil
	#	else 
	#		params[:status] == "true"
	#	end
	#	c = ARCondition.new(!@status.nil? ? ["active=?", @status] : nil)
	#
	#	@gitolite_public_keys = @user.gitolite_public_keys.all(:order => 'active DESC, created_at DESC', :conditions => c.conditions)
	#	respond_to do |format|
	#		format.html # index.html.erb
	#		format.json  { render :json => @gitolite_public_keys }
	#	end
	#end
	
	def edit
		redirect_to url_for(:controller => 'my', :action => 'account')
	end

	def delete
		@gitolite_public_key[:active] = 0
		@gitolite_public_key.save
		redirect_to url_for(:controller => 'my', :action => 'account')
	end

	def update
		if @gitolite_public_key.update_attributes(params[:public_key])
			flash[:notice] = l(:notice_public_key_updated)
			redirect_to url_for(:controller => 'my', :action => 'account')
		else
			render :action => 'edit'
		end
	end
	
	def create
		@gitolite_public_key = GitolitePublicKey.new(params[:public_key].merge(:user => @user))
		if @gitolite_public_key.save
			flash[:notice] = l(:notice_public_key_added)
		else
			@gitolite_public_key = GitolitePublicKey.new(:user => @user)
		end
		redirect_to url_for(:controller => 'my', :action => 'account')
	end
	
	#def show
	#	respond_to do |format|
	#		format.html # show.html.erb
	#		format.json { render :json => @gitolite_public_key }
	#	end
	#end
	
	protected
	
	def set_user_variable
		@user = User.current
	end
	
	def find_gitolite_public_key
		key = GitolitePublicKey.find_by_id(params[:id])
		if key and key.user == @user
			@gitolite_public_key = key
		elsif key
			render_403
		else
			render_404
		end
	end

end
