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
  ["jimbo", "jimbo@jim.com", "foobar"],
  ["ginger", "ginger@sexy.com", "foobar"]
]

sensor_list = [
  ["sensor1", Sensor.units["Fahrenheit"], Sensor.kinds["temperature"], false, 1, 1],
  ["sensor2", Sensor.units["feet"], Sensor.kinds["ultrasound"], false, 1, 1],
  ["sensor1", Sensor.units["Fahrenheit"], Sensor.kinds["temperature"], false, 1, 2],
  ["sensor1", Sensor.units["Celsius"], Sensor.kinds["temperature"], false, 1, 3],
  ["sensor1", Sensor.units["feet"], Sensor.kinds["ultrasound"], false, 1, 4]
]

event_list = [
  [98, 60.minutes.ago, false, 1],
  [97, 59.minutes.ago, false, 1],
  [98, 58.minutes.ago, false, 1],
  [95, 57.minutes.ago, false, 1],
  [92, 56.minutes.ago, false, 1],
  [91, 55.minutes.ago, false, 1],
  [90, 54.minutes.ago, false, 1],
  [85, 53.minutes.ago, false, 1],
  [82, 52.minutes.ago, false, 1],
  [80, 51.minutes.ago, false, 1],
  [75, 50.minutes.ago, false, 1],
  [74, 49.minutes.ago, false, 1],
  [77, 48.minutes.ago, false, 1],
  [79, 47.minutes.ago, false, 1],
  [82, 46.minutes.ago, false, 1],
  [82, 45.minutes.ago, false, 1],
  [81, 44.minutes.ago, false, 1],
  [78, 43.minutes.ago, false, 1],
  [76, 42.minutes.ago, false, 1],
  [75, 41.minutes.ago, false, 1],
  [74, 40.minutes.ago, false, 1],
  [73, 39.minutes.ago, false, 1],
  [70, 38.minutes.ago, false, 1],
  [66, 37.minutes.ago, false, 1],
  [66, 36.minutes.ago, false, 1],
  [66, 35.minutes.ago, false, 1],
  [66, 34.minutes.ago, false, 1],
  [67, 33.minutes.ago, false, 1],
  [67, 32.minutes.ago, false, 1],
  [69, 31.minutes.ago, false, 1],
  [67, 30.minutes.ago, false, 1],
  [66, 29.minutes.ago, false, 1],
  [20, 5.hours.ago, false, 2],
  [20, 4.hours.ago, false, 2],
  [8, 3.hours.ago, false, 2],
  [3, 80.minutes.ago, false, 2],
  [2.7, 70.minutes.ago, false, 2],
  [2, 60.minutes.ago, false, 2],
  [2.5, 55.minutes.ago, false, 2],
  [12, 50.minutes.ago, false, 2],
  [8, 45.minutes.ago, false, 2],
  [32, 8.hours.ago, false, 3],
  [38, 7.hours.ago, false, 3],
  [4, 9.hours.ago, false, 4],
  [5, 8.hours.ago, false, 4],
  [2, 10.hours.ago, false, 5]
]

user_list.each do | username, email, password |
  User.create(username: username, email: email, password: password)
end

sensor_list.each do | name, unit, kind, public, type_of_graph, user_id |
  Sensor.create(name: name, unit: unit, kind: kind, public: public, type_of_graph: type_of_graph, user_id: user_id)
end

event_list.each do | value, capture_time, notified, sensor_id |
  Event.create(value: value, capture_time: capture_time, notified: notified, sensor_id: sensor_id)
end
