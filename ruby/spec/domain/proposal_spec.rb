require 'spec_helper'
require 'securerandom'
require_relative '../../domain/proposal'
require_relative '../../domain/proponent'
require_relative '../../domain/warranty'

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

  describe 'adding a warranty' do
    context 'when the warranty is from an acceptable province' do
      it 'adds the warranty to the proposal' do
        warranty = instance_double(Warranty, province: 'SP')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_warranty(warranty)

        expect(proposal.warranties).to include(warranty)
      end
    end

    context 'when warranty is from a unacceptable province' do
      it 'does not adds the warranty to the proposal' do
        warranty_from_rs = instance_double(Warranty, province: 'RS')
        warranty_from_sc = instance_double(Warranty, province: 'SC')
        warranty_from_pr = instance_double(Warranty, province: 'PR')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_warranty(warranty_from_rs)
        proposal.add_warranty(warranty_from_sc)
        proposal.add_warranty(warranty_from_pr)

        aggregate_failures do
          expect(proposal.warranties).not_to include(warranty_from_rs)
          expect(proposal.warranties).not_to include(warranty_from_sc)
          expect(proposal.warranties).not_to include(warranty_from_pr)
        end
      end
    end
  end
end
