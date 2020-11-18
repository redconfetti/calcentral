# Identifies roles for the user based on Campus Solutions and CalNet LDAP affiliations
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

  def self.default_roles_hash
    LABELS.map {|label| [label, false]}.to_h
  end

  # provides applicable role symbols in array
  def self.active_roles(legacy_roles_hash)
    roles = legacy_roles_hash.keys
    roles.select {|r| legacy_roles_hash[r] }
  end

  def initialize(user)
    @user = user
  end

  # Roles sources from Campus Solutions affiliations via iHub
  def cs_roles
    self.class.default_roles_hash.merge({
      applicant: @user.applicant?,
      concurrentEnrollmentStudent: @user.uc_extension_student?,
      graduate: @user.graduate?,
      law: @user.law_student?,
      preSir: @user.pre_sir?,
      releasedAdmit: @user.released_admit?,
      student: @user.student? || @user.undergraduate? || @user.graduate?,
      undergrad: @user.undergraduate?,
    })
  end

  def unreleased_applicant?
    is_applicant = cs_roles.delete(:applicant)
    # Remove preSir since unreleased applicant can be sired or not.
    cs_roles.delete(:preSir)
    !!is_applicant && !cs_roles.has_value?(true)
  end
end
