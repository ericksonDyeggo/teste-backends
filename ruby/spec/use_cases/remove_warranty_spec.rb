require_relative '../../use_cases/remove_warranty'
require_relative '../../domain/proposal'

describe RemoveWarranty do
  context 'when removing a warranty' do
    context "and it finds it's proposal" do
      context 'and it finds the warranty' do
        it 'removes the warranty' do
          proposal_id = 'proposal_id'
          warranty_id = 'warranty_id'
          warranty = instance_spy(Warranty, id: warranty_id)
          proposal = instance_spy(Proposal, remove_warranty: warranty, warranties: [warranty])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          subject = described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, warranty_id
          )

          aggregate_failures do
            expect(subject).to be proposal
            expect(proposals_repository).to have_received(:get).with(proposal_id)
            expect(proposal).to have_received(:remove_warranty).with(warranty)
          end
        end
      end

      context 'and it does not finds the warranty' do
        it 'raises a WarrantyNotFound' do
          proposal_id = 'proposal_id'
          warranty_id = 'warranty_id'
          proposal = instance_spy(Proposal, remove_warranty: nil, warranties: [])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          expect do
            described_class.new(proposals_repository: proposals_repository).call(
              proposal_id, warranty_id
            )
          end
            .to raise_exception(WarrantyNotFound)
        end
      end
    end

    context "and it does not finds it's proposal" do
      it 'raises a ProposalNotFound exception' do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, warranty_id
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
