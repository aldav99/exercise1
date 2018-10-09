require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

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
      expect(user).to be_author_of(question)
    end

    it "another_user.author_of? question is false" do
      expect(another_user).to_not be_author_of(question)
    end

    it "Passing a object without user_id is false" do
      expect(user).to_not be_author_of(another_user)
    end
  end
end
