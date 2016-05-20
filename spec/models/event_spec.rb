require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { Event.new }

  it { is_expected.to belong_to(:sensor) }
end
