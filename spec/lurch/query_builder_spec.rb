RSpec.describe Lurch::QueryBuilder do
  let(:query_builder) { Lurch::QueryBuilder.new(params) }

  describe "#encode" do
    subject(:query) { query_builder.encode }

    context "given a hash with strings" do
      let(:params) { { foo: "bar", baz: "qux" } }

      it { is_expected.to eq "foo=bar&baz=qux" }
    end

    context "given a hash with nils" do
      let(:params) { { foo: nil, baz: nil } }

      it { is_expected.to eq "" }
    end

    context "given a hash with a nested array of strings" do
      let(:params) { { foo: %w(bar baz) } }

      it { is_expected.to eq "foo[]=bar&foo[]=baz" }
    end

    context "given a hash with a nested array of nils" do
      let(:params) { { foo: [nil, nil] } }

      it { is_expected.to eq "" }
    end

    context "given a hash with a nested hash of strings" do
      let(:params) { { foo: { bar: "baz" } } }

      it { is_expected.to eq "foo[bar]=baz" }
    end

    context "given a hash with a nested hash of nils" do
      let(:params) { { foo: { bar: nil } } }

      it { is_expected.to eq "" }
    end

    context "given a complex hash" do
      let(:params) do
        {
          foo: "str",
          bar: nil,
          baz: ["str", nil, ["str", nil], { plugh: "str", thud: nil }],
          qux: {
            quux: "str",
            corge: nil,
            grault: ["str", nil],
            garply: { waldo: "str", fred: nil }
          }
        }
      end

      it { is_expected.to eq "foo=str&baz[]=str&baz[][]=str&baz[][plugh]=str&qux[quux]=str&qux[grault][]=str&qux[garply][waldo]=str" }
    end
  end
end
