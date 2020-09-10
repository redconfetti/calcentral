class User::Profile::Roles
  LABELS = [
    :advisor,
    :applicant,
    :concurrentEnrollmentStudent,
    :expiredAccount,
    :exStudent,
    :faculty,
    :graduate,
    :guest,
    :law,
    :registered,
    :releasedAdmit,
    :staff,
    :student,
    :undergrad,
    :withdrawnAdmit,
    :preSir,
  ]

  def self.roles_hash
    LABELS.map {|label| [label, false]}.to_h
  end

  # provides applicable role symbols in array
  def self.roles_array(legacy_roles_hash)
    roles = legacy_roles_hash.keys
    roles.select {|r| legacy_roles_hash[r] }
  end

  def initialize(user)
    @user = user
  end

  # Roles sources from Campus Solutions affiliations via iHub
  def cs_roles
    self.class.roles_hash.merge({
      applicant: @user.is_applicant?,
      concurrentEnrollmentStudent: @user.is_uc_extension_student?,
      graduate: @user.is_graduate?,
      law: @user.is_law_student?,
      preSir: @user.is_pre_sir?,
      releasedAdmit: @user.is_released_admit?,
      student: @user.is_student? || @user.is_undergraduate? || @user.is_graduate?,
      undergrad: @user.is_undergraduate?,
    })
  end

  def is_unreleased_applicant?
    is_applicant = cs_roles.delete(:applicant)
    # Remove preSir since unreleased applicant can be sired or not.
    cs_roles.delete(:preSir)
    !!is_applicant && !cs_roles.has_value?(true)
  end
end
