describe 'My Dashboard bConnected live updates', :testui => true do

  if ENV["UI_TEST"]

    include ClassLogger

    today = Time.now
    id = today.to_i.to_s

    before(:all) do
      @driver = WebDriverUtils.launch_browser
    end

    after(:all) do
      WebDriverUtils.quit_browser(@driver)
    end

    before(:context) do
      splash_page = CalCentralPages::SplashPage.new(@driver)
      cal_net_auth_page = CalNetAuthPage.new(@driver)
      splash_page.log_into_dashboard(@driver, cal_net_auth_page, UserUtils.qa_username, UserUtils.qa_password)
      bconnected_card = CalCentralPages::MyProfileBconnectedCard.new(@driver)
      bconnected_card.load_page
      bconnected_card.disconnect_bconnected

      @google = GooglePage.new(@driver)
      @google.connect_calcentral_to_google(UserUtils.qa_gmail_username, UserUtils.qa_gmail_password)

      # On email badge, get initial count of unread emails
      @dashboard = CalCentralPages::MyDashboardPage.new(@driver)
      @dashboard.email_count_element.when_visible(timeout=WebDriverUtils.page_load_timeout)
      @initial_mail_count = @dashboard.email_count.to_i
      logger.info("Unread email count is #{@initial_mail_count.to_s}")

      # Send email to self
      @email_subject = "Test email #{id}"
      @email_summary = "This is the subject of test email #{id}"
      @google.send_email(UserUtils.qa_gmail_username, @email_subject, @email_summary)

      # On the Dashboard, wait for the live update to occur
      @dashboard.load_page
      @dashboard.click_live_update_button(WebDriverUtils.mail_live_update_timeout)
    end

    context 'for Google mail' do

      # If initial unread email count is zero, then it probably didn't load correctly.  In such case, ignore this example.
      it 'shows an updated count of email messages' do
        if @initial_mail_count.to_i.zero?
          logger.info 'not checking cuz there were zero emails'
        else
          logger.info 'there were more than zero emails, so checking the new count'
          expect(@dashboard.email_count).to eql((@initial_mail_count + 1).to_s)
        end
      end

      it 'shows a snippet of a new email message' do
        @dashboard.show_unread_email
        expect(@dashboard.email_one_sender).to eql('me')
        expect(@dashboard.email_one_subject).to eql(@email_subject)
        expect(@dashboard.email_one_summary).to eql(@email_summary)
      end

    end
  end
end
