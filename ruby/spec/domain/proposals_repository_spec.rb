require 'spec_helper'
require 'securerandom'
require_relative '../../domain/proposals_repository'
require_relative '../../domain/proposal'

describe ProposalsRepository do
  describe 'adding a proposal' do
    context 'when receives a proposal' do
      it 'adds the proposal' do
        proposal = instance_double(Proposal)
        base = []

        described_class.new(base: base).add(proposal)

        expect(base).to include(proposal)
      end
    end
  end

  describe 'getting a proposal' do
    context 'when it finds a proposal' do
      it 'returns the proposal' do
        id = SecureRandom.uuid
        proposal = instance_double(Proposal, id: id)
        base = [proposal]

        subject = described_class.new(base: base).get(id)

        expect(subject).to eq proposal
      end
    end

    context 'when it cant find a proposal' do
      it 'returns nil' do
        id = SecureRandom.uuid
        base = []

        subject = described_class.new(base: base).get(id)

        expect(subject).to be_nil
      end
    end
  end

  describe 'getting all proposals' do
    context 'when there is proposals' do
      it 'returns a list with the proposals' do
        proposal = instance_double(Proposal)
        another_proposal = instance_double(Proposal)
        base = [proposal, another_proposal]

        subject = described_class.new(base: base).all

        expect(subject).to eq base
      end
    end

    context 'when there is no proposals' do
      it 'returns a empty list' do
        subject = described_class.new.all

        expect(subject).to be_empty
      end
    end
  end

  describe 'finding a proposal by its number of monthly installments' do
    context 'when it finds a proposal' do
      it 'returns a list with the proposal' do
        number_of_monthly_installments = 48
        proposal = instance_double(Proposal, number_of_monthly_installments: number_of_monthly_installments)
        another_proposal = instance_double(Proposal, number_of_monthly_installments: 12)
        base = [proposal, another_proposal]

        subject = described_class.new(base: base).find do |proposal|
          proposal.number_of_monthly_installments == number_of_monthly_installments
        end

        aggregate_failures do
          expect(subject).to include(proposal)
          expect(subject).not_to include(another_proposal)
        end
      end
    end
  end

  describe 'removing a proposal' do
    context 'when the proposal is on the base' do
      it 'removes the proposal from base' do
        proposal = instance_double(Proposal)
        another_proposal = instance_double(Proposal)
        base = [proposal, another_proposal]

        described_class.new(base: base).remove(proposal)

        expect(base).not_to include(proposal)
      end
    end

    context 'when the proposal is not on the base' do
      it 'returns nil' do
        proposal = instance_double(Proposal)

        subject = described_class.new.remove(proposal)

        expect(subject).to be_nil
      end
    end
  end
end
