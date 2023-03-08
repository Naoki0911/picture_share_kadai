class ContactMailer < ApplicationMailer
  def contact_mail(post)
    @post = post

    mail to: @post.user.email, subject: "画像投稿完了メール"
  end
end
