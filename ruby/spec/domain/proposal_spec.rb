require 'spec_helper'
require 'securerandom'
require_relative '../../domain/proposal'
require_relative '../../domain/proponent'

describe Proposal do
  describe 'adding a proponent' do
    context 'when the proponent is 18 years old or older' do
      it 'adds the proponent to the proposal' do
        proponent = instance_double(Proponent, age: 18)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_proponent(proponent)

        expect(proposal.proponents).to include(proponent)
      end
    end

    context 'when the proponent is 17 years old or younger' do
      it 'does not adds the proponent to the proposal' do
        proponent = instance_double(Proponent, age: 17)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_proponent(proponent)

        expect(proposal.proponents).not_to include(proponent)
      end
    end
  end
end
