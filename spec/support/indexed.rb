shared_examples_for "indexed" do |model:|

  singular = model.name.singularize.underscore.to_sym
  plural = model.name.pluralize.underscore.to_sym

  let(:records) { create_list(singular, 2) }

  before { get :index }

  it "populates an array of all #{plural}" do
    expect(assigns(plural)).to match_array(records)
  end

  it 'renders index view' do
    expect(response).to render_template :index
  end
end