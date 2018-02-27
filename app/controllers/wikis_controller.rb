class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_if_user_is_allowed_to_update?, only: [:edit, :update]
  before_action :check_if_user_is_allowed_to_destroy?, only: [:destroy]

  def index
    if current_user && (current_user.admin? || current_user.premium?)
      @wikis = Wiki.all
    else
      @wikis = Wiki.publics
    end
  end

  def show
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash[:warning] = "There was a problem saving the wiki."
      render :new
    end
  end

  def edit
  end

  def update

    if @wiki.update(wiki_params)
      flash[:notice] = "Wiki was saved."
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
    unless current_user && (( current_user.admin?) || (current_user.premium? && (@wiki.user == current_user)) || !(@wiki.private))
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

end
