require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :sub_user }
  it { should belong_to :question_sub }
  it { should validate_uniqueness_of(:sub_user_id).scoped_to(:question_sub_id) }
  it { should validate_presence_of :sub_user_id }
  it { should validate_presence_of :question_sub_id }
end
