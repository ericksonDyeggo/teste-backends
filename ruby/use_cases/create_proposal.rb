require_relative '../domain/proposals_repository'
require_relative '../domain/proposal'

class CreateProposal
  def initialize(overrides = {})
    @proposal_class = overrides.fetch(:proposal_class) { Proposal }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, proposal_loan_value, proposal_number_of_monthly_installments)
    proposal = @proposal_class.new(
      id: proposal_id,
      loan_value: proposal_loan_value.to_f,
      number_of_monthly_installments: proposal_number_of_monthly_installments.to_i
    )

    @proposals_repository.add(proposal)
  end
end
