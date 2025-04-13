FactoryBot.define do
  factory :job do
    title { "Job title" }
    description { "Job description" }
    status { "pending" }
    association :user

    trait :with_invalid_status do
      status { "invalid_status" }
    end

    trait :without_title do
      title { nil }
    end

    trait :without_description do
      description { nil }
    end

    trait :without_status do
      status { nil }
    end

    trait :without_user do
      user { nil }
    end
  end
end
