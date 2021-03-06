class Message < ActiveRecord::Base
  # validates_presence_of :to
  # validates_presence_of :from
  # validates_presence_of :body
  has_and_belongs_to_many :contacts

  before_create :send_message


private


  def send_message
    begin
      response = RestClient::Request.new(
        method: :post,
        url: "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json",
        user: ENV['TWILIO_ACCOUNT_SID'],
        password: ENV['TWILIO_AUTH_TOKEN'],
        payload: { Body: body,
                   To: to,
                   From: from }
      ).execute
      # give acces to error in pry
    rescue RestClient::BadRequest => error
      error_message = JSON.parse(error.response)['message']
      errors.add(:base, error_message)
      false
    end
  end
end
