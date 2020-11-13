require_relative '../domain/proposals_repository'
require_relative '../domain/proponent'
require_relative 'proposal_not_found'

class AddProponent
  def initialize(overrides = {})
    @proponent_class = overrides.fetch(:proponent_class) { Proponent }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, proponent_id, proponent_name, proponent_age, proponent_monthly_income, proponent_is_main)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    proposal.add_proponent(
      @proponent_class.new(
        id: proponent_id, proposal_id: proposal_id,
        name: proponent_name, age: proponent_age.to_i,
        monthly_income: proponent_monthly_income.to_f,
        main: proponent_is_main == 'true'
      )
    )
  end
end
