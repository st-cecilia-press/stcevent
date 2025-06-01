require "faker"

FactoryBot.define do
  factory :event do
    title { "St. Cecilia #{rand(10).to_i}" }
    start_date { Faker::Date.between(from: 3.months.from_now, to: 6.months.from_now) }
    end_date { start_date + 1.day }
  end

  factory :page do
    title { Faker::Lorem.words(number: 4).join(" ").titlecase }
    body { Faker::Markdown.sandwich(sentences: 6) }
    event
    slug { Faker::Internet.slug }
  end

  factory :menu do
    order { rand(5) }
    name { Faker::Lorem.words(number: 2).join(" ").titlecase }
    event
  end

  factory :menu_item do
    order { rand(5) }
    name { Faker::Lorem.words(number: 2).join(" ").titlecase }
    url { "/" + Faker::Internet.slug }
    menu
  end

  factory :classroom do
    sequence(:name) { |n| "Classroom #{n}" }
    event
  end

  factory :difficulty do
    level { 1 }
    description { "Class is appropriate for nonmusicians" }
  end

  factory :activity_type do
    name { "Lecture" }
    description { "In this class the teacher will lecture to the students" }
  end

  factory :activity_subtype do
    name { "Vocal" }
    description { "This class is primarily for vocalists" }
  end

  factory :activity do
    title { Faker::Lorem.words(number: 4).join(" ").titlecase }
    description { Faker::Lorem.paragraph(sentence_count: 8) + "\n\n" + Faker::Lorem.paragraph }
    duration { Faker::Number.within(range: 30..120) }
    event
  end

  factory :person do
    name { Faker::Name.name }
    bio { Faker::Markdown.sandwich }
  end

  factory :schedule do
    event
  end

  factory :schedule_entry do
    classroom
    activity
    schedule
    start_time { Faker::Time.between(from: schedule.event.start_date, to: schedule.event.end_date) }
  end
end
