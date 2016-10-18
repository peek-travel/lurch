RSpec.describe Lurch::Changeset do
  let(:changeset) { Lurch::Changeset.new(:people) }

  describe "#add_related" do
    pending "TODO"
  end

  describe "#inspect" do
    subject { changeset.inspect }
    it { is_expected.to be_a(String) }
  end
end
