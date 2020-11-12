require_relative '../domain/proposals_repository'
require_relative '../domain/warranty'
require_relative 'proposal_not_found'

class AddWarranty
  def initialize(overrides = {})
    @warranty_class = overrides.fetch(:warranty_class) { Warranty }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, warranty_id, warranty_value, warranty_province)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    proposal.add_warranty(
      @warranty_class.new(
        id: warranty_id,
        proposal_id: proposal_id,
        value: warranty_value.to_f,
        province: warranty_province
      )
    )
  end
end
