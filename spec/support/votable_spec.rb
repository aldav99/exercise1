require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:user1) { create(:user)}
  let(:user2) { create(:user)}

  it "rate" do
    object1 = create(model.to_s.underscore.to_sym)
    object2 = create(model.to_s.underscore.to_sym)

    Vote.create(vote: 1, votable: object1, user: user1)
    Vote.create(vote: 1, votable: object1, user: user2)
    Vote.create(vote: -1, votable: object2, user: user1)

    expect(object1.rate).to eq(2)
    expect(object2.rate).to eq(-1)
  end
end