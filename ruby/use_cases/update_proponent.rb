require_relative '../domain/proposals_repository'
require_relative '../domain/proponent'
require_relative 'proposal_not_found'
require_relative 'proponent_not_found'

class UpdateProponent
  def initialize(overrides = {})
    @proponent_class = overrides.fetch(:proponent_class) { Proponent }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository }
  end

  def call(proposal_id, proponent_id, proponent_name, proponent_age, proponent_monthly_income, proponent_is_main)
    proposal = @proposals_repository.get(proposal_id)
    raise ProposalNotFound unless proposal

    proponent = select_proponent_from(proposal, proponent_id)
    raise ProponentNotFound unless proponent

    proponent.name = proponent_name
    proponent.age = proponent_age.to_i
    proponent.monthly_income = proponent_monthly_income.to_f
    proponent.main = proponent_is_main == 'true'

    proposal
  end

  private

  def select_proponent_from(proposal, proponent_id)
    proposal.proponents.select { |proponent| proponent.id == proponent_id }.first
  end
end
