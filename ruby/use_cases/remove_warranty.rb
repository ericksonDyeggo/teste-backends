require_relative '../domain/proposals_repository'
require_relative '../domain/warranty'
require_relative 'proposal_not_found'
require_relative 'warranty_not_found'

class RemoveWarranty
  def initialize(overrides = {})
    @warranty_class = overrides.fetch(:warranty_class) { Warranty }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, warranty_id)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    warranty = select_warranty_from(proposal, warranty_id)
    raise WarrantyNotFound unless warranty

    proposal.remove_warranty(warranty)

    proposal
  end

  private

  def select_warranty_from(proposal, warranty_id)
    proposal.warranties.select { |warranty| warranty.id == warranty_id }.first
  end
end
