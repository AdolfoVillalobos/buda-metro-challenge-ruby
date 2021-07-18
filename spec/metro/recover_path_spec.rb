require 'spec_helper'

RSpec.describe Metro::RecoverPath do

  def recover_path
    described_class.new(source, parents).recover_path(target)
  end

  let(:source) { 'A' }
  let(:target) { 'F' }
  let(:parents) do
    {
      "A" => nil,
      "B" => "A",
      "C" => "B",
      "D" => "C",
      "E" => "D",
      "F" => "E"
    }
  end

  describe '#recover_path' do
    context 'when source ! = target' do
      it 'returns path' do
        expect(recover_path).to eq(["A", "B", "C", "D", "E", "F"])
      end
    end
    context 'when source == target' do
      let(:target) { "A" }
      it 'returns path of one element' do
        expect(recover_path).to eq(["A"])
      end
    end
    context "when path is empty" do
      let(:parents) { Hash.new(nil) }
      it 'returns empty path' do
        expect(recover_path).to eq([])
      end
    end
  end
end
