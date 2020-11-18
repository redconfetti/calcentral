class User::Academics::Enrollment::Links
  TABLE = [
    { feed_key: :uc_add_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_ADD'},
    { feed_key: :uc_edit_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_UPD'},
    { feed_key: :uc_view_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_VIEW'},
    { feed_key: :request_late_class_changes, cs_link_key: 'UC_CX_GT_GRADEOPT_ADD'},
    { feed_key: :cross_campus_enroll, cs_link_key: 'UC_CX_STDNT_CRSCAMPENR'},
    { feed_key: :enrollment_center, cs_link_key: 'UC_SR_SS_ENROLLMENT_CENTER'},
  ]

  LATE_ENROLL_ACTION_LINK_CONFIG = {
    feed_key: :late_ugrd_enroll_action,
    cs_link_key: 'UC_CX_GT_SRLATEDROP_ADD'
  }

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def links
    link_config = TABLE.dup
    link_config.append(LATE_ENROLL_ACTION_LINK_CONFIG) if late_undergraduate_enrollment_action_allowed?
    link_config.inject({}) do |map, link_setting|
      cs_link_key = link_setting[:cs_link_key]
      map[link_setting[:feed_key]] = ::Links.find(cs_link_key);
      map
    end
  end

  def as_json(options={})
    HashConverter.camelize(links)
  end

  private

  def late_undergraduate_enrollment_action_allowed?
    whitelisted_roles = [
      'lettersAndScience',
      'ugrdEngineering',
      'ugrdEnvironmentalDesign',
      'ugrdNaturalResources',
      'ugrdHaasBusiness',
      'degreeSeeking',
    ]
    user.undergraduate? && (user.current_academic_roles & whitelisted_roles).any?
  end
end
