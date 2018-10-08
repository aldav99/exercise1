require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }

  describe "Associations" do
    it { should have_many(:answers) }
    it { should have_many(:questions).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe "author_of?" do
    it "user.author_of? question is true" do
      expect(user.author_of?(question)).to be_truthy
    end

    it "user.author_of? answer is true" do
      expect(user.author_of?(answer)).to be_truthy
    end

    it "another_user.author_of? question is false" do
      expect(another_user.author_of?(question)).to be_falsey
    end

    it "another_user.author_of? answer is false" do
      expect(another_user.author_of?(answer)).to be_falsey
    end
  end
end
