FactoryBot.define do
  factory :biker do
    email 'biker@example.com'
    password 'passwordpassword'
    username 'exemplar'
    description %{
      I'm an exemplar of an IRC biker.  I sit around on IRC talking
      about bikes more than I ride them, but I do ride them, and I
      even tinker on them at times.  I'm definitely on IRC, though.
    }.squish

    trait :admin do
      active true
      admin true
      email 'admin@example.com'
      username 'admin'
    end
  end
end
