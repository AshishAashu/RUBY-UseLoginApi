# Preview all emails at http://localhost:3000/rails/mailers/download_info_mailer
class DownloadInfoMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/download_info_mailer/downloaduserdata
  def downloaduserdata
    DownloadInfoMailer.downloaduserdata
  end

end
