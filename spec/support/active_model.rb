shared_examples_for "ActiveModel" do
  it 'should implement #errors' do
    expect(subject).to respond_to(:errors)
    expect(subject.errors[:hello]).to be_kind_of(Array)
  end

  it 'should implement #model_name and .model_name' do
    expect(subject.class).to respond_to(:model_name)

    model_name = subject.class.model_name

    expect(model_name).to respond_to(:to_str)
    expect(model_name.human).to respond_to(:to_str)
    expect(model_name.singular).to respond_to(:to_str)
    expect(model_name.plural).to respond_to(:to_str)

    expect(subject).to respond_to(:model_name)
    expect(subject.model_name).to eq(subject.class.model_name)
  end

  it 'should implement #persisted?' do
    expect(subject).to respond_to(:persisted?)
    expect([true, false]).to include(subject.persisted?)
  end

  it 'should implement #to_key' do
    expect(subject).to respond_to(:to_key)

    allow(subject).to receive(:persisted?).and_return(false)

    expect(subject.to_key).to be_nil
  end

  it 'should implement #to_param' do
    expect(subject).to respond_to(:to_param)

    allow(subject).to receive(:to_key).and_return([1])
    allow(subject).to receive(:persisted?).and_return(false)

    expect(subject.to_param).to be_nil
  end

  it 'should implement #to_partial_path' do
    expect(subject).to respond_to(:to_partial_path)
    expect(subject.to_partial_path).to be_kind_of(String)
  end
end