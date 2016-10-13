RSpec.describe Lurch::Store do
  let(:json_api_headers) { { "Content-Type" => "application/vnd.api+json", "Accept" => "application/vnd.api+json" } }

  let(:url) { "http://example.com" }
  let(:store) { Lurch::Store.new(url: url) }
  let(:type) { :people }

  describe "#from" do
    subject(:query) { store.from(type) }

    it { is_expected.to be_a(Lurch::Query) }

    it "passes the type on to the query" do
      expect(query.inspect).to eq "#<Lurch::Query[Person]>"
    end
  end

  describe "#peek" do
    subject(:resource) { store.peek(type, 1) }

    context "when the requested resource does not exist in the store" do
      it { is_expected.to be_nil }
    end

    context "when the requested resource exists in the store" do
      before do
        stored_resource = Lurch::StoredResource.new(store, "id" => 1, "type" => type.to_s)
        store.send(:push, stored_resource)
      end

      it { is_expected.to be_a(Lurch::Resource) }

      it "is the resource asked for" do
        expect(resource.id).to be 1
        expect(resource.type).to be type
      end
    end
  end

  describe "#save" do
    let(:resource) { Lurch::Resource.new(store, :person, 1) }
    let(:changeset) { Lurch::Changeset.new(resource, name: "John") }

    before do
      stub_request(:patch, "example.com/people/1")
        .with(body: JSON.dump(changeset.payload), headers: json_api_headers)
        .to_return(File.new(File.expand_path("../../responses/save.txt", __FILE__)))
    end

    it "sends a PATCH request to the server with the changeset payload and returns the modified resource" do
      person = store.save(changeset)
      expect(person.name).to eq "John"
    end
  end

  describe "#insert" do
    let(:changeset) { Lurch::Changeset.new(:person, name: "Jane") }

    before do
      stub_request(:post, "example.com/people")
        .with(body: JSON.dump(changeset.payload), headers: json_api_headers)
        .to_return(File.new(File.expand_path("../../responses/insert.txt", __FILE__)))
    end

    it "sends a POST request to the server with the changeset payload and returns the inserted resource" do
      person = store.insert(changeset)
      expect(person.name).to eq "Jane"
    end
  end

  describe "#delete" do
    let(:resource) { Lurch::Resource.new(store, :person, 1) }

    before do
      stub_request(:delete, "example.com/people/1")
        .with(headers: json_api_headers)
        .to_return(File.new(File.expand_path("../../responses/delete.txt", __FILE__)))
    end

    it "sends a DELETE request to the server for the given resource" do
      expect(store.delete(resource)).to be true
    end
  end

  describe "#add_relationship" do
    pending "TODO"
  end

  describe "#delete_relationship" do
    pending "TODO"
  end

  describe "#update_relationship" do
    pending "TODO"
  end
end
