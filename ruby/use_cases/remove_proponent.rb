require_relative '../domain/proposals_repository'
require_relative '../domain/proponent'
require_relative 'proposal_not_found'
require_relative 'proponent_not_found'

class RemoveProponent
  def initialize(overrides = {})
    @proponent_class = overrides.fetch(:proponent_class) { Proponent }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, proponent_id)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    proponent = select_proponent_from(proposal, proponent_id)
    raise ProponentNotFound unless proponent

    proposal.remove_proponent(proponent)

    proposal
  end

  private

  def select_proponent_from(proposal, proponent_id)
    proposal.warranties.select { |proponent| proponent.id == proponent_id }.first
  end
end
