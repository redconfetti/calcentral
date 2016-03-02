describe 'Delegated access', :testui => true do

  if ENV['UI_TEST'] && Settings.ui_selenium.layer == 'local'

    include ClassLogger

    begin
      @driver = WebDriverUtils.launch_browser
      timeout = WebDriverUtils.page_load_timeout
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)

      @splash_page = CalCentralPages::SplashPage.new @driver
      @dashboard_page = CalCentralPages::MyDashboardPage.new @driver
      @campus_page = CalCentralPages::MyCampusPage.new @driver
      @toolbox_page = CalCentralPages::MyToolboxPage.new @driver
      @cs_delegate_students_api = ApiCSDelegateAccessStudents.new @driver
      @cal_net_page = CalNetAuthPage.new @driver
      @status_api = ApiMyStatusPage.new @driver

      # Academics UI
      @academic_profile_card = CalCentralPages::MyAcademicsProfileCard.new @driver
      @status_card = CalCentralPages::MyAcademicsStatusAndBlocksCard.new @driver
      @semester_card = CalCentralPages::MyAcademicsSemestersCard.new @driver
      @final_exams_card = CalCentralPages::MyAcademicsFinalExamsCard.new @driver
      @advising_card = CalCentralPages::MyAcademicsAdvisingCard.new @driver
      @uni_reqts_card = CalCentralPages::MyAcademicsUniversityReqtsCard.new @driver
      @final_grades_card = CalCentralPages::MyAcademicsFinalGradesCard.new @driver
      @gpa_calc_card = CalCentralPages::MyAcademicsGPACalcCard.new @driver
      @classes_card = CalCentralPages::MyAcademicsClassesCard.new @driver
      @teaching_card = CalCentralPages::MyAcademicsTeachingCard.new @driver
      @class_page = CalCentralPages::MyAcademicsClassPage.new @driver
      @booklist_page = CalCentralPages::MyAcademicsBookListPage.new @driver
      @academics_api = ApiMyAcademicsPageSemesters.new @driver

      # Finances UI
      @finances_page = CalCentralPages::MyFinancesPages::MyFinancesLandingPage.new @driver
      @finances_details_page = CalCentralPages::MyFinancesPages::MyFinancesDetailsPage.new @driver
      @finances_fin_aid_page = CalCentralPages::MyFinancesPages::MyFinancesFinancialAidPage.new @driver
      @financials_api = ApiMyFinancialsPage.new @driver
      @cal_1_card_api = ApiMyCal1CardPage.new @driver
      @my_fin_aid_api = ApiMyFinAidPage.new @driver
      @cs_fin_aid_years_api = ApiCSAidYearsPage.new @driver
      @cs_fin_aid_data_api = ApiCSFinAidDataPage.new @driver

      # Profile UI
      @profile_basic = CalCentralPages::MyProfileBasicInfoCard.new @driver
      @profile_contact = CalCentralPages::MyProfileContactInfoCard.new @driver
      @profile_demographic = CalCentralPages::MyProfileDemographicCard.new @driver
      @profile_delegate = CalCentralPages::MyProfileDelegateAccessCard.new @driver
      @profile_disclosure = CalCentralPages::MyProfileInfoDisclosureCard.new @driver
      @profile_title_iv = CalCentralPages::MyProfileTitleIVCard.new @driver
      @profile_bconnected = CalCentralPages::MyProfileBconnectedCard.new @driver

      test_output = UserUtils.initialize_output_csv self
      CSV.open(test_output, 'wb') do |heading|
        heading << ['UID', 'Student UID', 'Student', 'Faculty', 'Staff', 'Enrollment', 'Grades', 'Financial', 'Phone']
      end

      test_delegates = UserUtils.load_test_users.select { |user| user['delegatedAccess'] }
      test_delegates.each do |delegate|

        begin
          uid = delegate['uid']
          logger.info("Delegate UID is #{uid}")
          @splash_page.load_page
          @splash_page.basic_auth uid
          @cs_delegate_students_api.get_json @driver

          students = @cs_delegate_students_api.students
          logger.debug "There are #{students.length} student accounts associated with delegate UID #{uid}"

          # DELEGATED ACCESS UI ON TOOLBOX PAGE

          @toolbox_page.load_page

          shows_delegate_welcome = WebDriverUtils.verify_block do
            @toolbox_page.delegate_msg_heading_element.when_visible timeout
            @toolbox_page.delegate_msg_element.when_visible timeout
          end
          it ("shows delegate UID #{uid} the delegate welcome message") { expect(shows_delegate_welcome).to be true }

          shows_less = @toolbox_page.delegate_msg_expanded_element.visible?
          it ("shows delegate UID #{uid} a collapsed view of delegate instructions") { expect(shows_less).to be false }

          @toolbox_page.show_more
          shows_more = @toolbox_page.delegate_msg_expanded_element.visible?
          it ("shows delegate UID #{uid} an expanded view of delegate instructions") { expect(shows_more).to be true }

          ui_students = @toolbox_page.all_delegator_names
          api_students = @cs_delegate_students_api.student_names
          it ("shows delegate UID #{uid} the list of linked students") { expect(ui_students).to eql(api_students) }

          subscribe_calendar_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.subscribe_to_calendar_element, 'UC Berkeley Calendar - Office Of The Registrar')
          it ("shows delegate UID #{uid} a link to 'Subscribe to the Academic Calendar'") { expect(subscribe_calendar_link).to be true }

          grad_div_calendar_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.grad_div_deadlines_element, 'Degree Deadlines | Berkeley Graduate Division')
          it ("shows delegate UID #{uid} a link to 'Graduate Division Degree Deadlines'") { expect(grad_div_calendar_link).to be true }

          calparents_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.cal_parents_element, 'UC Berkeley Cal Parents')
          it ("shows delegate UID #{uid} a link to 'CalParents'") { expect(calparents_link).to be true }

          important_dates_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.important_dates_element, 'Cal Parents - Important Dates for Parents')
          it ("shows delegate UID #{uid} a link to 'Important Dates for Parents'") { expect(important_dates_link).to be true }

          visiting_campus_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.visiting_campus_element, 'Cal Parents - Visiting the Campus')
          it ("shows delegate UID #{uid} a link to 'Visiting the Campus'") { expect(visiting_campus_link).to be true }

          jobs_and_careers_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.jobs_and_careers_element, 'UC Berkeley - Cal Parents')
          it ("shows delegate UID #{uid} a link to 'Jobs & Careers'") { expect(jobs_and_careers_link).to be true }

          housing_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.housing_element, 'Cal Parents - Housing')
          it ("shows delegate UID #{uid} a link to 'Housing'") { expect(housing_link).to be true }

          financial_info_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.financial_info_element, 'Cal Parents - Financial Information')
          it ("shows delegate UID #{uid} a link to 'Financial Information'") { expect(financial_info_link).to be true }

          academics_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.academics_element, 'UC Berkeley - Cal Parents')
          it ("shows delegate UID #{uid} a link to 'Academics'") { expect(academics_link).to be true }

          academic_calendar_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.academic_calendar_element, 'Student Calendar - Office Of The Registrar')
          it ("shows delegate UID #{uid} a link to 'Academic Calendar'") { expect(academic_calendar_link).to be true }

          newscenter_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.news_center_element, 'Berkeley News | News from the University of California, Berkeley')
          it ("shows delegate UID #{uid} a link to 'UC Berkeley NewsCenter'") { expect(newscenter_link).to be true }

          berkeley_news_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.berkeley_news_element, 'UC Berkeley - In the News')
          it ("shows delegate UID #{uid} a link to 'Berkeley in the News'") { expect(berkeley_news_link).to be true }

          daily_cal_link = WebDriverUtils.verify_external_link(@driver, @toolbox_page.daily_cal_element, 'The Daily Californian | Berkeley\'s News')
          it ("shows delegate UID #{uid} a link to 'The Daily Californian'") { expect(daily_cal_link).to be true }

          # DELEGATE VIEW-AS EXPERIENCE

          if students.any?

            students.each do |student|
              student_uid = student['uid'].to_i
              student_name = student['fullName']
              privileges = student['privileges']
              logger.debug "Student UID is #{student_uid} with privileges #{privileges}"

              is_student = nil
              is_faculty = nil
              is_staff = nil

              begin

                if privileges['phone'] && !privileges['viewEnrollments'] && !privileges['viewGrades'] && !privileges['financial']

                  # TODO - what user see for phone-only?

                else

                  @toolbox_page.load_page
                  logger.info "Delegate UID #{uid} is viewing as student UID #{student_uid}"
                  @toolbox_page.delegate_view_as student_name

                  current_url = @driver.current_url
                  if privileges['viewEnrollments'] || privileges['viewGrades']
                    it "lands delegate UID #{uid} on the Academics page for UID #{student_uid}" do
                      expect(current_url).to eql("#{WebDriverUtils.base_url}/academics")
                    end

                    @status_api.get_json @driver
                    is_student = @status_api.is_student?
                    is_faculty = @status_api.is_faculty?
                    is_staff = @status_api.is_staff?

                    CSV.open(test_output, 'a+') do |row|
                      row << [uid, student_uid, is_student, is_faculty, is_staff, privileges['viewEnrollments'], privileges['viewGrades'],
                              privileges['financial'], privileges['phone']]
                    end

                    @academics_api.get_json @driver
                    @academic_profile_card.load_page
                    @academic_profile_card.profile_card_element.when_visible timeout

                    # Profile - name
                    shows_profile_name = @academic_profile_card.name?
                    it ("shows delegate UID #{uid} the academic profile name for UID #{student_uid}") { expect(shows_profile_name).to be true }

                    # Profile - career
                    unless @academics_api.has_no_standing?
                      shows_career = @academic_profile_card.career?
                      it ("shows delegate UID #{uid} the academic career for UID #{student_uid}") { expect(shows_career).to be true }
                    end

                    # Profile - GPA
                    shows_gpa = @academic_profile_card.gpa?
                    if @academics_api.gpa == '0.0' || !privileges['viewGrades']
                      it ("shows delegate UID #{uid} no GPA for UID #{student_uid}") { expect(shows_gpa).to be false }
                    else
                      it ("shows delegate UID #{uid} the GPA for UID #{student_uid}") { expect(shows_gpa).to be true }
                    end

                    # Reg Status
                    shows_reg_status = @status_card.status_table?
                    it ("shows delegate UID #{uid} no registration status for UID #{student_uid}") { expect(shows_reg_status).to be false }

                    # Active Blocks
                    shows_active_blocks = @status_card.active_blocks_table?
                    it ("shows delegate UID #{uid} no active blocks for UID #{student_uid}") { expect(shows_active_blocks).to be false }

                    # Final Exams
                    shows_exams = @final_exams_card.all_exam_courses.any?
                    if @academics_api.has_exam_schedules
                      it ("shows delegate UID #{uid} the final exams for UID #{student_uid}") { expect(shows_exams).to be true }
                    end

                    # L&S Advising
                    shows_advising = @advising_card.make_appt_link?
                    it ("shows delegate UID #{uid} no L and S advising card for UID #{student_uid}") { expect(shows_advising).to be false }

                    # University Requirements
                    shows_uni_reqts = @uni_reqts_card.reqts_table?
                    it ("shows delegate UID #{uid} no university requirements for UID #{student_uid}") { expect(shows_uni_reqts).to be false }

                    # My Academics student semester cards

                    student_semesters = @academics_api.all_student_semesters
                    if student_semesters.any?

                      api_semesters = @academics_api.all_student_semesters
                      api_semesters_count = api_semesters.length
                      api_semesters_count += 1 if @academics_api.addl_credits

                      @semester_card.show_more if @semester_card.show_more_element.visible?
                      ui_semesters_count = @semester_card.semester_card_elements.length

                      it ("shows delegate UID #{uid} all the semester cards for UID #{student_uid}") { expect(ui_semesters_count).to eql(api_semesters_count) }

                      api_semesters.each do |semester|
                        @semester_card.load_page
                        @semester_card.page_heading_element.when_visible timeout
                        @semester_card.show_more if @semester_card.show_more_element.visible?

                        semester_name = @academics_api.semester_name semester
                        semester_courses = @academics_api.semester_courses(semester)

                        if @academics_api.past_semesters(api_semesters).include? semester

                          ui_grades = @semester_card.grades(@driver, semester_name)
                          api_grades = @academics_api.semester_grades(api_semesters, semester_courses, semester).reject { |grade| grade.empty? }

                          if privileges['viewGrades']
                            it "shows delegate UID #{uid} the #{semester_name} grades on My Academics for UID #{student_uid}" do
                              expect(ui_grades.any?).to be true
                              expect(ui_grades).to eql(api_grades)
                            end
                          else
                            it "shows delegate UID #{uid} no #{semester_name} grades on My Academics for UID #{student_uid}" do
                              expect(ui_grades.any?).to be false
                              expect(ui_grades).to eql(api_grades)
                            end
                          end
                        end

                        # Student semester pages

                        semester_slug = semester_name.downcase.gsub(' ', '-')
                        blocks_semester_page = WebDriverUtils.verify_block do
                          @semester_card.load_semester_page semester_slug
                          @semester_card.not_found_element.when_present timeout
                        end
                        it ("prevents UID #{uid} from viewing the #{semester_name} semester page for UID #{student_uid}") { expect(blocks_semester_page).to be true }

                        blocks_booklist = WebDriverUtils.verify_block do
                          @booklist_page.load_page semester_slug
                          @booklist_page.not_found_element.when_present timeout
                        end
                        it ("prevents UID #{uid} from viewing the #{semester_name} book list page for UID #{student_uid}") { expect(blocks_booklist).to be true }

                        # Student class pages

                        semester_courses.each do |course|

                          class_page_url = "/academics/semester/#{semester_slug}/class/#{@academics_api.course_slug course}"
                          blocks_class_page = WebDriverUtils.verify_block do
                            @semester_card.load_class_page class_page_url
                            @semester_card.not_found_element.when_present timeout
                          end
                          it ("prevents UID #{uid} from viewing the #{class_page_url} class page for UID #{student_uid}") { expect(blocks_class_page).to be true }

                        end
                      end
                    end

                    # My Academics teaching semester cards

                    teaching_semesters = @academics_api.all_teaching_semesters
                    it ("shows delegate UID #{uid} no teaching data for UID #{student_uid}") { expect(teaching_semesters).to be nil }

                    shows_teaching_card = @teaching_card.course_code_elements.any?
                    it ("shows delegate UID #{uid} no teaching card for UID #{student_uid}") { expect(shows_teaching_card).to be false }

                    @academic_profile_card.click_my_finances_link if privileges['finances']

                  elsif privileges['financial']

                    it ("lands delegate UID #{uid} on the Finances page") { expect(current_url).to eql("#{WebDriverUtils.base_url}/finances") }

                  end

                  if privileges['financial']

                    it ("lands delegate UID #{uid} with 'finances-only' privileges on My Finances") { expect(current_url).to eql("#{WebDriverUtils.base_url}/finances") }

                    @my_fin_aid_api.get_json @driver
                    @cs_fin_aid_years_api.get_json @driver

                    # Billing Summary
                    sees_billing_summary = WebDriverUtils.verify_block do
                      @finances_page.load_page
                      @finances_page.account_balance_element_element.when_visible timeout
                    end
                    it ("shows delegate UID #{uid} the billing summary for UID #{student_uid}") { expect(sees_billing_summary).to be true }

                    sees_payment_button = @finances_page.make_payment_link?
                    it ("shows delegate UID #{uid} the 'Make a Payment' button for UID #{student_uid}") { expect(sees_payment_button).to be true }

                    # Cal 1 Card
                    @finances_page.cal_1_card_content_element.when_visible timeout
                    sees_cal_1_card = @finances_page.debit_account_header?
                    it ("shows delegate UID #{uid} the Cal 1 Card card for UID #{student_uid}") { expect(sees_cal_1_card).to be true }

                    # FinAid Messages (legacy)
                    @finances_page.fin_messages_heading_element.when_visible timeout
                    if @my_fin_aid_api.all_activity.any?
                      shows_finaid_msgs = @finances_page.fin_messages_list?
                      it ("shows delegate UID #{uid} the MyFinAid messages card for UID #{student_uid}") { expect(shows_finaid_msgs).to be true }
                    end

                    # Financial Resources links
                    @finances_page.fin_resources_list_element.when_visible timeout
                    shows_fin_resources = @finances_page.fin_resources_list?
                    it ("shows delegate UID #{uid} Financial Resources link for UID #{student_uid}") { expect(shows_fin_resources).to be true }

                    # Financial Aid (CS)
                    unless @cs_fin_aid_years_api.feed.nil?
                      if @cs_fin_aid_years_api.fin_aid_years.any?
                        @finances_page.finaid_content_element.when_visible timeout
                        if @cs_fin_aid_years_api.t_and_c_approval @cs_fin_aid_years_api.fin_aid_years.last
                          # TODO - Finances - FinAid - SIS - sees all if "finances" but no CS links
                          it "shows delegate UID #{uid} Financial Aid info for UID #{student_uid}"
                        end
                      end
                    end

                    # Billing - Detail

                    shows_details_summary = WebDriverUtils.verify_block do
                      @finances_details_page.load_page
                      @finances_details_page.account_balance_element_element.when_visible timeout
                    end
                    it ("shows delegate UID #{uid} the billing summary on the Details page for UID #{student_uid}") { expect(shows_details_summary).to be true }

                    shows_transactions = @finances_details_page.transaction_table?
                    it ("shows delegate UID #{uid} the list of transactions on the Details page for UID #{student_uid}") { expect(shows_transactions).to be true }

                  else

                    # My Finances - hidden

                    shows_finances_link = @finances_page.my_finances_link?
                    it ("shows delegate UID #{uid} no My Finances link for UID #{student_uid}") { expect(shows_finances_link).to be false }

                    blocks_finances = WebDriverUtils.verify_block do
                      @finances_page.load_page
                      @finances_page.not_found_element.when_present timeout
                    end
                    it ("prevents delegate UID #{uid} from hitting the Finances page for UID #{student_uid} directly") { expect(blocks_finances).to be true }

                  end

                  # My Dashboard - always hidden

                  shows_dashboard_link = @finances_page.my_dashboard_link?
                  it ("shows delegate UID #{uid} no My Dashboard link for UID #{student_uid}") { expect(shows_dashboard_link).to be false }

                  blocks_dashboard = WebDriverUtils.verify_block do
                    @dashboard_page.load_page
                    @dashboard_page.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Dashboard for UID #{student_uid} directly") { expect(blocks_dashboard).to be true }

                  # My Campus

                  sees_campus_links = WebDriverUtils.verify_block do
                    @campus_page.load_page
                    @campus_page.links_list_element.when_visible timeout
                  end
                  it ("shows delegate UID #{uid} My Campus links for UID #{student_uid}") { expect(sees_campus_links).to be true }

                  # bConnected badges

                  shows_bmail = @campus_page.email_badge?
                  it ("shows delegate UID #{uid} no bConnected email for UID #{student_uid}") { expect(shows_bmail).to be false }

                  shows_bcal = @campus_page.calendar_badge?
                  it ("shows delegate UID #{uid} no bConnected invites for UID #{student_uid}") { expect(shows_bcal).to be false }

                  shows_bdrive = @campus_page.drive_badge?
                  it ("shows delegate UID #{uid} no bConnected documents for UID #{student_uid}") { expect(shows_bdrive).to be false }

                  # Profile

                  shows_profile_popover = @campus_page.profile_icon?
                  it ("shows delegate UID #{uid} the Profile popover for UID #{student_uid}") { expect(shows_profile_popover).to be true }

                  shows_profile_link = @campus_page.profile_link?
                  it ("shows delegate UID #{uid} no Profile link for UID #{student_uid}") { expect(shows_profile_link).to be false }

                  blocks_basic_info = WebDriverUtils.verify_block do
                    @profile_basic.load_page
                    @profile_basic.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile basic info page for UID #{student_uid}") { expect(blocks_basic_info).to be true }

                  blocks_contact_info = WebDriverUtils.verify_block do
                    @profile_contact.load_page
                    @profile_contact.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile contact info page for UID #{student_uid}") { expect(blocks_contact_info).to be true }


                  blocks_demographics = WebDriverUtils.verify_block do
                    @profile_demographic.load_page
                    @profile_demographic.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile demographic info page for UID #{student_uid}") { expect(blocks_demographics).to be true }

                  blocks_delegate_access = WebDriverUtils.verify_block do
                    @profile_delegate.load_page
                    @profile_delegate.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile delegate access page for UID #{student_uid}") { expect(blocks_delegate_access).to be true }

                  blocks_disclosure = WebDriverUtils.verify_block do
                    @profile_disclosure.load_page
                    @profile_disclosure.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile info disclosure page for UID #{student_uid}") { expect(blocks_disclosure).to be true }

                  blocks_title_iv = WebDriverUtils.verify_block do
                    @profile_title_iv.load_page
                    @profile_title_iv.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile Title IV page for UID #{student_uid}") { expect(blocks_title_iv).to be true }

                  blocks_bconnected = WebDriverUtils.verify_block do
                    @profile_bconnected.load_page
                    @profile_bconnected.not_found_element.when_present timeout
                  end
                  it ("prevents delegate UID #{uid} from hitting the Profile bConnected page for UID #{student_uid}") { expect(blocks_bconnected).to be true }

                  # bCourses - site creation

                  blocks_site_creation = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/canvas/embedded/site_creation"
                    wait.until { @driver.find_element(:xpath => '//h1[text()="Access Denied"]') }
                  end
                  it ("prevents UID #{uid} from reaching Canvas site creation for UID #{student_uid}") { expect(blocks_site_creation).to be true }

                  # bCourses - course site creation

                  blocks_create_course_site = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/canvas/embedded/create_course_site"
                    wait.until { @driver.find_element(:xpath => '//h1[text()="Unexpected Error"]') }
                  end
                  it ("prevents UID #{uid} from reaching Canvas create a course site for UID #{student_uid}") { expect(blocks_create_course_site).to be true }

                  # bCourses - project site creation

                  blocks_create_project_site = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/canvas/embedded/create_project_site"
                    wait.until { @driver.find_element(:xpath => '//h1[text()="Access Denied"]') }
                  end
                  it ("prevents UID #{uid} from reaching Canvas create a project site for UID #{student_uid}") { expect(blocks_create_project_site).to be true }

                  # bCourses - user provisioning

                  blocks_user_provision = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/canvas/embedded/user_provision"
                    wait.until { @driver.find_element(:xpath => '//h1[text()="Access Denied"]') }
                  end
                  it ("prevents UID #{uid} from reaching Canvas user provisioning for UID #{student_uid}") { expect(blocks_user_provision).to be true }

                  # bCourses - add user to site

                  # TODO - Canvas - find user to add

                  # bCourses - view course captures

                  # TODO - Canvas - webcasts

                  # bCourses - manage official sections

                  # TODO - Canvas - official sections

                  # bCourses - view roster photos

                  # TODO - Canvas - roster photos

                  # bCourses - export E-Grades

                  # TODO - Canvas - export E-Grades

                  # OEC

                  blocks_oec = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/oec"
                    wait.until { @driver.find_element(:xpath => '//h1[text()="Access Denied"]') }
                  end
                  it ("prevents UID #{uid} from reaching OEC for UID #{student_uid}") { expect(blocks_oec).to be true }

                  # CCAdmin

                  blocks_ccadmin = WebDriverUtils.verify_block do
                    @driver.get "#{WebDriverUtils.base_url}/ccadmin"
                    wait.until { @cal_net_page.username? }
                  end
                  it ("prevents UID #{uid} from reaching CCAdmin for UID #{student_uid}") { expect(blocks_ccadmin).to be true }

                end
              rescue => e
                logger.error e.message + "\n" + e.backtrace.join("\n")
              end
            end
          else
            # TODO Verify Toolbox view if you have no students
          end
        rescue => e
          logger.error e.message + "\n" + e.backtrace.join("\n")
        end
      end
    rescue => e
      logger.error e.message + "\n" + e.backtrace.join("\n ")
    ensure
      WebDriverUtils.quit_browser(@driver)
    end
  end
end
