FactoryBot.define do
  factory :vote do
    product_id { 1 }
    comment { "MyText" }
    star { 1 }
    user_name { "MyString" }
    user_email { "MyString" }
  end
end
