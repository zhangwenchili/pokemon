class CatchNotificationMailer < ApplicationMailer
  def new_catch
    @user = params[:user]
    @instance = params[:instance]
    @label = @instance.nickname.presence || @instance.species.name
    mail(to: @user.email, subject: "You caught #{@label}!")
  end
end
