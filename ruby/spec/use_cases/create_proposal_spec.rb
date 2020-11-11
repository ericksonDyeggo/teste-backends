require_relative '../../use_cases/create_proposal'

describe CreateProposal do
  context 'when creating a proposal' do
    it 'creates a proposal' do
      proposal_id = 'proposal_id'
      proposal_loan_value = 30000.0
      proposal_number_of_monthly_installments = 48
      proposal = instance_double(Proposal)
      proposal_class = class_spy(Proposal, new: proposal)
      proposals_repository = instance_spy(ProposalsRepository, add: proposal)

      subject = described_class.new(proposal_class: proposal_class, proposals_repository: proposals_repository).call(
        proposal_id: proposal_id,
        proposal_loan_value: proposal_loan_value,
        proposal_number_of_monthly_installments: proposal_number_of_monthly_installments
      )

      aggregate_failures do
        expect(subject).to be proposal
        expect(proposal_class).to have_received(:new).with(
          id: proposal_id,
          loan_value: proposal_loan_value,
          number_of_monthly_installments: proposal_number_of_monthly_installments
        )
        expect(proposals_repository).to have_received(:add).with(proposal)
      end
    end
  end
end
