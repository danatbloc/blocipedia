module WikisHelper

  def user_can_edit?(wiki)
    current_user && (( current_user.admin?) || (current_user.premium? && (wiki.user == current_user)) || !(wiki.private) || (wiki.users.pluck(:id).include?(current_user.id)) )
  end

  def user_can_delete?(wiki)
    current_user && (( current_user.admin?) || (wiki.user == current_user))
  end

  def user_can_privatize_the_wiki?(wiki)
    if wiki.user
      current_user.admin? || (current_user.premium? && (wiki.user == current_user))
    else
      current_user.admin? || current_user.premium?
    end
  end
end
