class RentMailer < ApplicationMailer

  def send_rent_info rent
    @rent = rent
    mail to: @rent.mini_pitch.user.email, subject: t(".subject")
  end
end
