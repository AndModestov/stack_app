require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  it { should validate_uniqueness_of(:votable_id).scoped_to([:user_id, :votable_type]) }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it { should belong_to :user }
  it { should belong_to :votable }
end
