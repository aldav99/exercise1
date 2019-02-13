 shared_examples_for 'usable' do

  

  # it { should validate_presence_of :title }
  # it { should have_many(:answers).dependent(:destroy) }
  # it { should have_db_index(:user_id) }




  

#-------------------------------------------------------
it { should validate_presence_of :body }
it { should have_many :attachments }
it { should have_many(:votes).dependent(:destroy) }
it { should have_many(:comments).dependent(:destroy) }
it { should accept_nested_attributes_for :attachments }
it_behaves_like "votable"
#--------------------------------------------------------




#   let(:resource) { create(described_class.name.underscore) }

#   describe '#add_follower' do
#     it 'should add a new follower' do
#       expect { resource.add_follower }.
#         to change { resource.followers.count }.from(0).to(1)
#     end
#   end
end

