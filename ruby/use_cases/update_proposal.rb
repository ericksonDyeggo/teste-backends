require_relative '../domain/proposals_repository'

class UpdateProposal
  def initialize(overrides = {})
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id:, proposal_loan_value:, proposal_number_of_monthly_installments:)
    proposal = @proposals_repository.get(proposal_id)
    proposal.loan_value = proposal_loan_value
    proposal.number_of_monthly_installments = proposal_number_of_monthly_installments

    proposal
  end
end
