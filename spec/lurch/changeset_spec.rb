RSpec.describe Lurch::Changeset do
  let(:changeset) { Lurch::Changeset.new(:people) }

  describe "#set" do
    pending "TODO"
  end

  describe "#set_related" do
    pending "TODO"
  end

  describe "#inspect" do
    subject { changeset.inspect }
    it { is_expected.to be_a(String) }
  end
end
