require_relative '../../use_cases/remove_proponent'
require_relative '../../domain/proposal'

describe RemoveProponent do
  context 'when removing a proponent' do
    context "and it finds it's proposal" do
      context 'and it finds the proponent' do
        it 'removes the proponent' do
          proposal_id = 'proposal_id'
          proponent_id = 'proponent_id'
          proponent = instance_spy(Proponent, id: proponent_id)
          proposal = instance_spy(Proposal, remove_proponent: proponent, warranties: [proponent])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          subject = described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proponent_id
          )

          aggregate_failures do
            expect(subject).to be proposal
            expect(proposals_repository).to have_received(:get).with(proposal_id)
            expect(proposal).to have_received(:remove_proponent).with(proponent)
          end
        end
      end

      context 'and it does not finds the proponent' do
        it 'raises a ProponentNotFound' do
          proposal_id = 'proposal_id'
          proponent_id = 'proponent_id'
          proposal = instance_spy(Proposal, remove_proponent: nil, warranties: [])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          expect do
            described_class.new(proposals_repository: proposals_repository).call(
              proposal_id, proponent_id
            )
          end
            .to raise_exception(ProponentNotFound)
        end
      end
    end

    context "and it does not finds it's proposal" do
      it 'raises a ProposalNotFound exception' do
        proposal_id = 'proposal_id'
        proponent_id = 'proponent_id'
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proponent_id
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
