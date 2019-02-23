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

  describe 'subscribe_author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it {expect(Subscriber.find_by(question_id: question).user).to eq user}
  end

  describe 'subscriber(user)' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscriber) { create(:subscriber, question: question, user: user) }

    it {expect(question.subscriber(user)).to eq subscriber}
  end
end
