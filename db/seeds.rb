# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_list = [
  ["asdf", "asdf@email.com","asdf"],
  ["david", "dk@email.com","foobar"],
  ["juan", "juan@email.com","foobar"],
  ["jimbo", "jimbo@jim.com", "foobar"]
]

# sensor_list = [
#   ["sensor1", 1, 1, ]
# ]
user_list.each do | username, email, password |
  User.create(username: username, email: email, password: password)
end
