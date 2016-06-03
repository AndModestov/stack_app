require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe 'confirm! method' do
    let(:auth){ create(:authorization, token: 'mysecrettocen') }

    it 'should confirm authorization' do
      expect(auth.confirmed).to be false

      expect{ auth.confirm! }.to change { auth.confirmed }.from(false).to(true)
    end
  end
end
