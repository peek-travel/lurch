RSpec.describe Lurch::Resource do
  let(:url) { "http://example.com" }
  let(:store) { Lurch::Store.new(url: url) }
  let(:resource) { Lurch::Resource.new(store, :person, 1) }

  describe "#loaded?" do
    subject { resource.loaded? }

    context "when the resource is not loaded" do
      it { is_expected.to be false }
    end
  end

  describe "#fetch" do
    pending "TODO"
  end

  describe "#attributes" do
    subject(:attributes) { resource.attributes }

    context "when the resource is not loaded" do
      it "should raise a NotLoaded error" do
        expect { attributes }.to raise_error(Lurch::Errors::NotLoaded)
      end
    end
  end

  describe "#relationships" do
    subject(:relationships) { resource.relationships }

    context "when the resource is not loaded" do
      it "should raise a NotLoaded error" do
        expect { relationships }.to raise_error(Lurch::Errors::NotLoaded)
      end
    end
  end

  describe "#==" do
    pending "TODO"
  end

  describe "#eql?" do
    pending "TODO"
  end

  describe "#[]" do
    pending "TODO"
  end

  describe "#resource_class_name" do
    subject { resource.resource_class_name }
    it { is_expected.to eq "Person" }
  end

  describe "#inspect" do
    subject { resource.inspect }
    it { is_expected.to be_a(String) }
  end
end
