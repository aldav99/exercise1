require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }
  it { should have_db_index([:question_id, :user_id]).unique(true) }
end
