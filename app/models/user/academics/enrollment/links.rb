class User::Academics::Enrollment::Links
  TABLE = [
    { feed_key: :uc_add_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_ADD'},
    { feed_key: :uc_edit_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_UPD'},
    { feed_key: :uc_view_class_enrollment, cs_link_key: 'UC_CX_GT_SSCNTENRL_VIEW'},
    { feed_key: :request_late_class_changes, cs_link_key: 'UC_CX_GT_GRADEOPT_ADD'},
    { feed_key: :cross_campus_enroll, cs_link_key: 'UC_CX_STDNT_CRSCAMPENR'},
    { feed_key: :late_ugrd_enroll_action, cs_link_key: 'UC_CX_GT_SRLATEDROP_ADD' }
  ]

  def links
    TABLE.inject({}) do |map, link_setting|
      cs_link_key = link_setting[:cs_link_key]
      map[link_setting[:feed_key]] = LinkFetcher.fetch_link(cs_link_key);
      map
    end
  end
end
