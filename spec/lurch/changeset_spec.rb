RSpec.describe Lurch::Changeset do
  let(:type) { :people }
  let(:type_or_resource) { type }
  let(:changes) { {} }
  let(:changeset) { Lurch::Changeset.new(type_or_resource, changes) }

  describe "#payload" do
    subject(:payload) { changeset.payload }

    context "when given a type" do
      it { is_expected.to include("type" => type) }
      it { is_expected.not_to include("id") }
    end

    context "when given a resource" do
      let(:type_or_resource) { Lurch::Resource.new(nil, type, 1) }

      it { is_expected.to include("type" => type) }
      it { is_expected.to include("id" => 1) }
    end

    context "when given some changes" do
      let(:name) { "Mr. Example" }
      let(:changes) { { name: name } }

      it { is_expected.to include("data" => { "attributes" => { "name" => name } }) }
    end

    context "when given changes with underscored keys" do
      let(:email_address) { "example@example.com" }
      let(:changes) { { email_address: email_address } }

      it "dasherizes the keys" do
        expect(payload).to include("data" => { "attributes" => { "email-address" => email_address } })
      end
    end
  end

  describe "#inspect" do
    subject { changeset.inspect }
    it { is_expected.to be_a(String) }
  end
end
