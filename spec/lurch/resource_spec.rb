RSpec.describe Lurch::Resource do
  let(:url) { "http://example.com" }
  let(:store) { Lurch::Store.new(url) }
  let(:resource_object) do
    {
      "id" => 1,
      "type" => "people",
      "attributes" => {
        "name" => "Bob"
      },
      "relationships" => {
        "hobbies" => { "links" => { "related" => "#{url}/people/1/hobbies" } }
      }
    }
  end
  let(:stored_resource) { Lurch::StoredResource.new(store, resource_object) }
  let(:resource) { Lurch::Resource.new(store, :person, 1) }

  describe "#loaded?" do
    subject { resource.loaded? }

    context "when the resource is not loaded" do
      it { is_expected.to be false }
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to be true }
    end
  end

  describe "#fetch" do
    pending "TODO"
  end

  describe "#attributes" do
    subject(:attributes) { resource.attributes }

    context "when the resource is not loaded" do
      it "should raise a NotLoaded error" do
        expect { attributes }.to raise_error Lurch::Errors::NotLoaded
      end
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to eq name: "Bob" }
    end
  end

  describe "#relationships" do
    subject(:relationships) { resource.relationships }

    context "when the resource is not loaded" do
      it "should raise a NotLoaded error" do
        expect { relationships }.to raise_error Lurch::Errors::NotLoaded
      end
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to include hobbies: kind_of(Lurch::Relationship) }
    end
  end

  describe "#==" do
    subject { resource == other_resource }

    context "when the other resource has the same id and type as this one" do
      let(:other_resource) { Lurch::Resource.new(store, :person, 1) }

      it { is_expected.to be true }
    end

    context "when the other resource has the same id but a different type" do
      let(:other_resource) { Lurch::Resource.new(store, :hobby, 1) }

      it { is_expected.to be false }
    end

    context "when the other resource has a different id but the same type" do
      let(:other_resource) { Lurch::Resource.new(store, :person, 2) }

      it { is_expected.to be false }
    end

    context "when the other resource has a different id and type" do
      let(:other_resource) { Lurch::Resource.new(store, :hobby, 2) }

      it { is_expected.to be false }
    end
  end

  describe "#eql?" do
    subject { resource.eql? other_resource }

    context "when the other resource has the same id and type as this one" do
      let(:other_resource) { Lurch::Resource.new(store, :person, 1) }

      it { is_expected.to be true }
    end

    context "when the other resource has the same id but a different type" do
      let(:other_resource) { Lurch::Resource.new(store, :hobby, 1) }

      it { is_expected.to be false }
    end

    context "when the other resource has a different id but the same type" do
      let(:other_resource) { Lurch::Resource.new(store, :person, 2) }

      it { is_expected.to be false }
    end

    context "when the other resource has a different id and type" do
      let(:other_resource) { Lurch::Resource.new(store, :hobby, 2) }

      it { is_expected.to be false }
    end
  end

  describe "#[]" do
    let(:attribute_name) { :name }
    subject(:attribute) { resource[attribute_name] }

    context "when the resource is not loaded" do
      it "should raise a NotLoaded error" do
        expect { attribute }.to raise_error Lurch::Errors::NotLoaded
      end
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to eq "Bob" }
    end
  end

  describe "#resource_class_name" do
    subject { resource.resource_class_name }
    it { is_expected.to eq "Person" }
  end

  describe "#inspect" do
    subject { resource.inspect }

    context "when the resource is not loaded" do
      it { is_expected.to include "not loaded" }
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to_not include "not loaded" }
    end
  end

  describe "#respond_to_missing?" do
    subject(:respond_to) { resource.respond_to?(:name) }

    context "when the resource is not loaded" do
      it { is_expected.to be false }
    end

    context "when the resource is loaded" do
      before { store.send(:push, stored_resource) }

      it { is_expected.to be true }
    end
  end

  describe "#method_missing" do
    context "when accessing an attribute" do
      subject(:name) { resource.name }

      context "when the resource is not loaded" do
        it "should raise a NotLoaded error" do
          expect { name }.to raise_error Lurch::Errors::NotLoaded
        end
      end

      context "when the resource is loaded" do
        before { store.send(:push, stored_resource) }

        it { is_expected.to eq "Bob" }
      end
    end

    context "when accessing a relationship" do
      subject(:hobbies) { resource.hobbies }

      context "when the resource is not loaded" do
        it "should raise a NotLoaded error" do
          expect { hobbies }.to raise_error Lurch::Errors::NotLoaded
        end
      end

      context "when the resource is loaded" do
        before { store.send(:push, stored_resource) }

        it { is_expected.to be_a Lurch::Relationship }
      end
    end

    context "when accessing a non-existent property" do
      subject(:foo) { resource.foo }

      context "when the resource is not loaded" do
        it "should raise a NotLoaded error" do
          expect { foo }.to raise_error Lurch::Errors::NotLoaded
        end
      end

      context "when the resource is loaded" do
        before { store.send(:push, stored_resource) }

        it "should raise a NoMethodError error" do
          expect { foo }.to raise_error NoMethodError
        end
      end
    end
  end
end
