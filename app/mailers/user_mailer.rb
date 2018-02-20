class UserMailer < ApplicationMailer
  default from: "dafaso1@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup.subject
  #
  def signup(user)
    
    headers["Message-ID"] = "<user/#{user.id}@pure-eyrie-71103.herokuapp.com>"
    headers["In-Reply-To"] = "<user/#{user.id}@pure-eyrie-71103.herokuapp.com>"
    headers["References"] = "<user/#{user.id}@pure-eyrie-71103.herokuapp.com>"

    @user = user

    mail(to: user.email, subject: "Blocipedia Sign Up")

  end

end
