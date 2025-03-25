require "faker"

FactoryBot.define do
  factory :event do
    title { "St. Cecilia #{rand(10).to_i}" }
    start_date { Faker::Date.between(from: 3.months.from_now, to: 6.months.from_now) }
    end_date { start_date + 1.day }
  end

  factory :page, class: "Page" do
    title { Faker::Lorem.words(number: 4).join(" ").titlecase }
    body { Faker::Markdown.sandwich(sentences: 6) }
    event
    slug { Faker::Lorem.word }
  end

  factory :menu_item do
    order { rand(5) }
    name { Faker::Lorem.words(number: 2).join(" ").titlecase }
    event
  end
end
