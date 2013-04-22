FactoryGirl.define do
  # passing the symbol :user to factory command, we tell Factory Girl that 
  # the subsequent definition is for a User model object
  factory :user do
    name      "Fengjiang Li"
    email     "fengjiang_li@yahoo.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end