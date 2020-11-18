# Usage:
#
# user = build(:user)
# => #<User::Current:0x6f89ad03 @uid=1>
#
# user2 = build(:user)
# => #<User::Current:0x73c09a98 @uid=2>
#
# oski = build(:user, {uid: '61889'})
# => #<User::Current:0x5dc120ab @uid="61889">
#
FactoryBot.define do
  factory :user, class: User::Current do
    initialize_with { new(uid) }
    sequence(:uid) { |n| n }
  end
end
