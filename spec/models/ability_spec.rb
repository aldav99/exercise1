require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question_other) { create(:question, user: other) }
    let(:question_user) { create(:question, user: user) }
    let(:answer_other) { create(:answer, user: other) }
    let(:answer_user) { create(:answer, user: user) }
    let(:vote_answer) { create(:vote, votable: answer_other, user: user) }
    

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }
    it { should be_able_to :create, Subscriber }
    it { should be_able_to :destroy, Subscriber }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }


    it { should be_able_to :vote_up, create(:answer, user: other), user: user }
    it { should_not be_able_to :vote_up, create(:answer, user: user), user: user }

    it { should be_able_to :vote_up, create(:question, user: other), user: user }
    it { should_not be_able_to :vote_up, create(:question, user: user), user: user }

    it { should_not be_able_to :vote_up, question: question_other, user: user }
    it { should_not be_able_to :vote_up, answer: answer_other, user: user }

    it { should be_able_to :vote_reset, question: question_other, user: user }
    it { should be_able_to :vote_reset, answer: answer_other, user: user }

    it { should_not be_able_to :destroy, create(:attachment, attachmentable: answer_other), user: user }
    it { should be_able_to :destroy, create(:attachment, attachmentable: answer_user), user: user }

    it { should_not be_able_to :destroy, create(:attachment, attachmentable: question_other), user: user }
    it { should be_able_to :destroy, create(:attachment, attachmentable: question_user), user: user }

    it { should_not be_able_to :best, create(:answer, question: question_other), user: user }
    it { should be_able_to :best, create(:answer, question: question_user), user: user }
  end
end




