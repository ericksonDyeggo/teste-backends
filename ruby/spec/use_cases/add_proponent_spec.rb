require_relative '../../use_cases/add_proponent'
require_relative '../../domain/proposal'

describe AddProponent do
  context 'when adding a proponent' do
    context "and it finds it's proposal" do
      it "creates a proponent and add it to it's proposal" do
        proposal_id = 'proposal_id'
        proponent_id = 'proponent_id'
        proponent_name = 'Roger'
        proponent_age = 18
        proponent_monthly_income = 5000.0
        proponent_is_main = true
        proponent = instance_spy(Proponent)
        proponent_class = class_spy(Proponent, new: proponent)
        proposal = instance_spy(Proposal)
        proposals_repository = instance_spy(ProposalsRepository, get: proposal)

        subject = described_class.new(proponent_class: proponent_class, proposals_repository: proposals_repository).call(
          proposal_id, proponent_id, proponent_name, proponent_age.to_s, proponent_monthly_income.to_s, proponent_is_main.to_s
        )

        aggregate_failures do
          expect(subject).to be proposal
          expect(proposals_repository).to have_received(:get).with(proposal_id)
          expect(proponent_class).to have_received(:new).with(
            id: proponent_id,
            proposal_id: proposal_id,
            name: proponent_name,
            age: proponent_age,
            monthly_income: proponent_monthly_income,
            main: proponent_is_main
          )
          expect(proposal).to have_received(:add_proponent).with(proponent)
        end
      end
    end

    context "and it does not finds it's proposal" do
      it 'raises a ProposalNotFound exception' do
        proposal_id = 'proposal_id'
        proponent_id = 'proponent_id'
        proponent_name = 'Roger'
        proponent_age = 18
        proponent_monthly_income = 5000.0
        proponent_is_main = true
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proponent_id, proponent_name, proponent_age.to_s, proponent_monthly_income.to_s, proponent_is_main.to_s
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
