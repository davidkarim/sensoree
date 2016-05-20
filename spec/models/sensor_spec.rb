require 'rails_helper'

RSpec.describe Sensor, type: :model do
  subject(:sensor) { Sensor.new }

  it { is_expected.to have_many(:events) }
  it { is_expected.to belong_to(:user) }
end
