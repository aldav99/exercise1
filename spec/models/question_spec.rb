require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it_behaves_like 'usable'

  it { should validate_presence_of :title }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_db_index(:user_id) }

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like 'calculates reputation'
  end
end
