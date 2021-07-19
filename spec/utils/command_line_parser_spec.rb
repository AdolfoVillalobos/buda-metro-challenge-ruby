require 'spec_helper'

RSpec.describe Metro::CommandLineParser do
  def parse
    described_class.parse(argv)
  end
  describe '#parse' do
    context 'when input is valid' do
      context 'when all args are valid' do
        let(:argv) { %w[-f data/base.json -s A -t F -c red] }
        let(:output) do
          {
            train_color: 2,
            network_file: 'data/base.json',
            source: 'A',
            target: 'F'
          }
        end
        it 'returs parsed args' do
           expect(parse).to eq(output)
        end
      end
      context 'when train color is not given' do
        let(:argv) { %w[-f data/base.json -s A -t F] }
        let(:output) do
          {
            train_color: 0,
            network_file: 'data/base.json',
            source: 'A',
            target: 'F'
          }
        end
        it 'returs parsed args with default value for train color' do
         expect(parse).to eq(output)
        end
      end
    end

    context 'when input is invalid' do
      context 'when file is not given' do
        let(:argv) { %w[--source A --target F --train-color green] }
        it { expect { parse }.to raise_error(RuntimeError, 'FILE missing') }
      end

      context 'when source is not given' do
        let(:argv) { %w[--file data/base.json --target F --train-color green] }
        it { expect { parse }.to raise_error(RuntimeError, 'SOURCE missing') }
      end

      context 'when source is not given' do
        let(:argv) { %w[--file data/base.json --source A --train-color green] }
        it { expect { parse }.to raise_error(RuntimeError, 'TARGET missing') }
      end

      context 'when train color is not supported' do
        let(:argv) { %w[--file data/base.json --source A --target F --train-color la121lala] }
        it { expect { parse }.to raise_error(RuntimeError, 'TRAIN COLOR not supported') }
      end
    end
  end
end
