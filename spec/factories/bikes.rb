FactoryBot.define do
  factory :bike do
    name 'Vroom Vroom'
    description 'It is very fast!'
    association :owner, factory: :biker

    trait :sheila do
      name 'Sheila'
    end
  end
end
