require_relative '../domain/proposals_repository'
require_relative 'proposal_not_found'

class UpdateProposal
  def initialize(overrides = {})
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, proposal_loan_value, proposal_number_of_monthly_installments)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    proposal.loan_value = proposal_loan_value.to_f
    proposal.number_of_monthly_installments = proposal_number_of_monthly_installments.to_i

    proposal
  end
end
