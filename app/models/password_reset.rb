class PasswordReset < ApplicationRecord
  validates :user_type, :user_id, :otp_digest, :expires_at, presence: true

  def set_otp(raw_otp)
    self.otp_digest = Digest::SHA256.hexdigest(raw_otp)
  end

  def valid_otp?(raw_otp)
    self.otp_digest == Digest::SHA256.hexdigest(raw_otp) && Time.current <= self.expires_at
  end
end
