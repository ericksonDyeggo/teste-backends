require_relative '../../use_cases/update_proposal'
require_relative '../../domain/proposal'

describe UpdateProposal do
  context 'when updating a proposal' do
    context 'and it finds the proposal' do
      it 'updates a proposal' do
        proposal_id = 'proposal_id'
        proposal_loan_value = 30000.0
        proposal_number_of_monthly_installments = 48
        proposal = instance_spy(Proposal)
        proposals_repository = instance_spy(ProposalsRepository, get: proposal)

        subject = described_class.new(proposals_repository: proposals_repository).call(
          proposal_id, proposal_loan_value.to_s, proposal_number_of_monthly_installments.to_s
        )

        aggregate_failures do
          expect(subject).to be proposal
          expect(proposals_repository).to have_received(:get).with(proposal_id)
          expect(proposal).to have_received(:loan_value=).with(proposal_loan_value)
          expect(proposal).to have_received(:number_of_monthly_installments=).with(proposal_number_of_monthly_installments)
        end
      end
    end

    context 'and it does not finds the proposal' do
      it 'raises a ProposalNotFound exception' do
        proposal_id = 'proposal_id'
        proposal_loan_value = 30000.0
        proposal_number_of_monthly_installments = 48
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proposal_loan_value.to_s, proposal_number_of_monthly_installments.to_s
          )
        end.to raise_exception(ProposalNotFound)
      end
    end
  end
end
