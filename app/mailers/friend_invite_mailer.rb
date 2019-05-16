class FriendInviteMailer < ApplicationMailer
  def invite(current_user, handle, email)
    @user = current_user
    @handle = handle
    mail(to: email, subject: "#{@user.github_login} has invited you to join Turing Tutorials!")
  end
end
