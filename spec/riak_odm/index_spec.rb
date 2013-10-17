require 'spec_helper'

describe RiakOdm::Index do
  let(:bin_index) { RiakOdm::Index.new('nice_index', type: :binary) }
  let(:int_index) { RiakOdm::Index.new('nice_index', type: :integer) }

  describe '#initialize' do

  end

  describe '#full_name' do
    context 'the type is :binary' do
      it 'returns the name given in the initializer with the \'_bin\' suffix' do
        expect(bin_index.full_name).to eq('nice_index_bin')
      end
    end

    context 'the type is :integer' do
      it 'returns the name given in the initializer with the \'_int\' suffix' do
        expect(int_index.full_name).to eq('nice_index_int')
      end
    end
  end
end