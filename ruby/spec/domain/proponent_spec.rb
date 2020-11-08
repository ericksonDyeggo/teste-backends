require 'spec_helper'
require_relative '../../domain/proponent'

describe Proponent do
  describe 'asking if it is the main proponent' do
    context 'when it is a main proponent' do
      it 'returns true' do
        main = true

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).to be_main
      end
    end

    context 'when it is not a main proponent' do
      it 'returns false' do
        main = false

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).not_to be_main
      end
    end
  end
end
