require 'rails_helper'

describe CalculateReputationJob do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'calculates and update user reputation' do
    expect(Reputation).to receive(:calculate).with(question).and_return(5)
    expect { CalculateReputationJob.perform_now(question) }.to change(user, :reputation).by(5)
  end
end

# RSpec.describe CalculateReputationJob, type: :job do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
