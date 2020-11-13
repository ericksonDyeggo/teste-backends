require 'spec_helper'
require 'securerandom'
require_relative '../../domain/proposal'
require_relative '../../domain/proponent'
require_relative '../../domain/warranty'

describe Proposal do
  describe 'adding a proponent' do
    context 'when the proponent is 18 years old or older' do
      it 'adds the proponent to the proposal' do
        proponent = instance_double(Proponent, age: 18)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        subject = proposal.add_proponent(proponent)

        aggregate_failures do
          expect(proposal.proponents).to include(proponent)
          expect(subject).to be proposal
        end
      end
    end

    context 'when the proponent is 17 years old or younger' do
      it 'does not adds the proponent to the proposal' do
        proponent = instance_double(Proponent, age: 17)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_proponent(proponent)

        expect(proposal.proponents).not_to include(proponent)
      end
    end
  end

  describe 'removing a proponent' do
    context 'when it finds the proponent' do
      it 'removes the proponent' do
        proponent = instance_double(Proponent)
        proponents = [proponent]
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, proponents: proponents)

        subject = proposal.remove_proponent(proponent)

        aggregate_failures do
          expect(subject).to be proponent
          expect(proponents).not_to include(proponent)
        end
      end
    end

    context 'when it does not finds the proponent' do
      it 'returns nil' do
        proponent = instance_double(Proponent)
        proponents = []
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, proponents: proponents)

        subject = proposal.remove_proponent(proponent)

        expect(subject).to be_nil
      end
    end
  end

  describe 'adding a warranty' do
    context 'when the warranty is from an acceptable province' do
      it 'adds the warranty to the proposal' do
        warranty = instance_double(Warranty, province: 'SP')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        subject = proposal.add_warranty(warranty)

        aggregate_failures do
          expect(proposal.warranties).to include(warranty)
          expect(subject).to be proposal
        end
      end
    end

    context 'when warranty is from a unacceptable province' do
      it 'does not adds the warranty to the proposal' do
        warranty_from_rs = instance_double(Warranty, province: 'RS')
        warranty_from_sc = instance_double(Warranty, province: 'SC')
        warranty_from_pr = instance_double(Warranty, province: 'PR')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_warranty(warranty_from_rs)
        proposal.add_warranty(warranty_from_sc)
        proposal.add_warranty(warranty_from_pr)

        aggregate_failures do
          expect(proposal.warranties).not_to include(warranty_from_rs)
          expect(proposal.warranties).not_to include(warranty_from_sc)
          expect(proposal.warranties).not_to include(warranty_from_pr)
        end
      end
    end
  end

  describe 'removing a warranty' do
    context 'when it finds the warranty' do
      it 'removes the warranty' do
        warranty = instance_double(Warranty)
        warranties = [warranty]
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, warranties: warranties)

        subject = proposal.remove_warranty(warranty)

        aggregate_failures do
          expect(subject).to be warranty
          expect(warranties).not_to include(warranty)
        end
      end
    end

    context 'when it does not finds the warranty' do
      it 'removes the warranty' do
        warranty = instance_double(Warranty)
        warranties = [warranty]
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, warranties: warranties)

        subject = proposal.remove_warranty(warranty)

        aggregate_failures do
          expect(subject).to be warranty
          expect(warranties).not_to include(warranty)
        end
      end
    end
  end

  describe 'validating a proposal' do
    context 'when the loan value is greater or equal to R$ 30.000 and lower than R$ 3.000.000' do
      it 'returns true' do
        loan_value = 30_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be true
      end
    end

    context 'when the loan value is lower than R$ 30.000' do
      it 'returns false' do
        loan_value = 29_999
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when the loan value is greater than R$ 3.000.000' do
      it 'returns false' do
        loan_value = 3_000_000.01
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when the number of monthly installments is greater or equal to 2 years and less than 15 years' do
      it 'returns true' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be true
      end
    end

    context 'when the number of monthly installments is less than 2 years' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 23
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when the number of monthly installments is greater than 15 years' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 181
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when theres is only one proponent' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when there is two main proponents' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18)
        secondary_proponent = instance_double(Proponent, main?: true, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when there is no main proponents' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: false, age: 18)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context "when the main proponent's monthly income is valid for the installment" do
      it 'returns true' do
        loan_value = 48_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be true
      end
    end

    context "when the main proponent's monthly income is invalid for the installment" do
      it 'returns false' do
        loan_value = 48_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: false)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end

    context 'when there is one warranty' do
      context "and it's value is twice the loan value" do
        it 'returns true' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 100_000, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)

          subject = proposal.valid?

          expect(subject).to be true
        end
      end

      context "and it's value isn't twice the loan value" do
        it 'returns false' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 99_999, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)

          subject = proposal.valid?

          expect(subject).to be false
        end
      end
    end

    context 'when there is two or more warranties' do
      context "and it's summed up value is twice the loan value" do
        it 'returns true' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          second_warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          proposal.add_warranty(second_warranty)

          subject = proposal.valid?

          expect(subject).to be true
        end
      end

      context "and it's summed up value isn't twice the loan value" do
        it 'returns false' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          second_warranty = instance_double(Warranty, value: 49_999, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          proposal.add_warranty(second_warranty)

          subject = proposal.valid?

          expect(subject).to be false
        end
      end
    end

    context 'when there is no warranty' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)

        subject = proposal.valid?

        expect(subject).to be false
      end
    end
  end
end
