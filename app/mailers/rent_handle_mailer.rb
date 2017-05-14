class RentHandleMailer < ApplicationMailer
  
  def send_rent_info rent
    @rent = rent
    mail to: @rent.user.email, subject: t(".subject")
  end
end
