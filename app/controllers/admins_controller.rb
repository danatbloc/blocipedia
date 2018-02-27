class AdminsController < ApplicationController
  before_action :check_if_user_is_admin

  def upgrade

    if params[:task].present?
      user = User.find(params[:id])

      if params[:task] == "downgrade"

        user.standard!

        pwikis = user.wikis.privates

        pwikis.each do |wiki|
          wiki.update_attribute("private", false)
        end

      else
        user.premium!
      end

      flash[:notice] = "#{user.name} status updated."

      # redirect here so that button doesn't resubmit if admin page is refreshed
      redirect_to admins_upgrade_path
    end

    @users = User.select{|u| !(u.admin?) }.sort_by{|u|u.name}

  end
end
