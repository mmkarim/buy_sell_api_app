require "rails_helper"

describe Transaction do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:asset) }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:type) }
end
