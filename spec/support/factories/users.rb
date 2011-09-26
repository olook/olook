Factory.define :user do |f|
  f.password "123456"
  f.password_confirmation "123456"
  f.email "user@mail.com"
  f.first_name "User First Name"
end
