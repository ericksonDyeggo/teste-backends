require_relative '../../use_cases/add_warranty'
require_relative '../../domain/proposal'

describe AddWarranty do
  context 'when adding a warranty' do
    context "and it finds it's proposal" do
      it "creates a warranty and add it to it's proposal" do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        warranty_value = 200000.0
        warranty_province = 'SP'
        warranty = instance_spy(Warranty)
        warranty_class = class_spy(Warranty, new: warranty)
        proposal = instance_spy(Proposal)
        proposals_repository = instance_spy(ProposalsRepository, get: proposal)

        subject = described_class.new(warranty_class: warranty_class, proposals_repository: proposals_repository).call(
          proposal_id, warranty_id, warranty_value.to_s, warranty_province
        )

        aggregate_failures do
          expect(subject).to be proposal
          expect(proposals_repository).to have_received(:get).with(proposal_id)
          expect(warranty_class).to have_received(:new).with(
            id: warranty_id,
            proposal_id: proposal_id,
            value: warranty_value,
            province: warranty_province
          )
          expect(proposal).to have_received(:add_warranty).with(warranty)
        end
      end
    end

    context "and it does not finds it's proposal" do
      it 'raises a ProposalNotFound exception' do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        warranty_value = 200000.0
        warranty_province = 'SP'
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, warranty_id, warranty_value.to_s, warranty_province
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
