class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_if_user_is_allowed_to_update?, only: [:edit, :update]
  before_action :check_if_user_is_allowed_to_destroy?, only: [:destroy]

  def index
    @wikis = Wiki.all
  end

  def show
  end

  def new
    @wiki = Wiki.new
    @users = collaborator_list
  end

  def create
    @users = collaborator_list
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      update_collaborators if params[:access].present?
      redirect_to @wiki
    else
      flash[:warning] = "There was a problem saving the wiki."
      render :new
    end
  end

  def edit
    @users = collaborator_list
  end

  def update
    @users = collaborator_list
    if @wiki.update(wiki_params)
      flash[:notice] = "Wiki was saved."
      update_collaborators if params[:access].present?
      redirect_to @wiki
    else
      flash[:warning] = "There was a problem saving the wiki."
      render :edit
    end

  end

  def destroy

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end

  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def check_if_user_is_allowed_to_update?
    unless current_user && (( current_user.admin?) || (current_user.premium? && (@wiki.user == current_user)) || !(@wiki.private) || (@wiki.users.pluck(:id).include?(current_user.id)) )
      flash[:notice] = "You cannot edit this private wiki."
      redirect_to @wiki
    end
  end

  def check_if_user_is_allowed_to_destroy?
    unless (current_user.admin? || (@wiki.user == current_user))
      flash[:notice] = "You cannot delete this private wiki."
      redirect_to @wiki
    end
  end

  def set_wiki
    @wiki = Wiki.find(params[:id])
  end

  def collaborator_list
    users = User.all
    admins = User.select{ |u| u.admin? }
    users - admins - [current_user]
  end

  def update_collaborators
    old_collaborators = @wiki.users.pluck(:id)
    new_collaborators = params[:access].map(&:to_i)
    delete_collaborators = old_collaborators - new_collaborators
    add_collaborators = new_collaborators - old_collaborators

    delete_collaborators.each do |id|
      c = Collaborator.find{|c| c.user_id == id && c.wiki_id == @wiki.id}
      c.destroy
    end

    add_collaborators.each do |id|
      Collaborator.create( user_id: id, wiki_id: @wiki.id )
    end
  end

end
