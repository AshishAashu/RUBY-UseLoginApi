require 'test_helper'

class DownloadInfoMailerTest < ActionMailer::TestCase
  test "downloaduserdata" do
    mail = DownloadInfoMailer.downloaduserdata
    assert_equal "Downloaduserdata", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
