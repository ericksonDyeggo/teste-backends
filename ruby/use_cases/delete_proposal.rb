require_relative '../domain/proposals_repository'
require_relative 'proposal_not_found'

class DeleteProposal
  def initialize(overrides = {})
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id:)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    @proposals_repository.remove(proposal)
  end
end
