require 'spec_helper'
require_relative '../../domain/proponent'

describe Proponent do
  describe 'asking if it is the main proponent' do
    context 'when it is a main proponent' do
      it 'returns true' do
        main = true

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).to be_main
      end
    end

    context 'when it is not a main proponent' do
      it 'returns false' do
        main = false

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).not_to be_main
      end
    end
  end

  describe 'asking if the monthly income is valid for a installment' do
    context "when the proponent's age is between 18 and 24 years" do
      context "and the proponent's monthly income is at least 4 times the value of the installment" do
        it 'returns true' do
          age = 18
          monthly_income = 4_000
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be true
        end
      end

      context "and the proponent's monthly income is less than 4 times the value of the installment" do
        it 'returns false' do
          age = 18
          monthly_income = 3_999
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be false
        end
      end
    end

    context "when the proponent's age is between 24 and 50 years" do
      context "and the proponent's monthly income is at least 3 times the value of the installment" do
        it 'returns true' do
          age = 24
          monthly_income = 3_000
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be true
        end
      end

      context "and the proponent's monthly income is less than 3 times the value of the installment" do
        it 'returns false' do
          age = 24
          monthly_income = 2_999
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be false
        end
      end
    end

    context "when the proponent's age is over 50 years" do
      context "and the proponent's monthly income is at least 2 times the value of the installment" do
        it 'returns true' do
          age = 51
          monthly_income = 2_000
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be true
        end
      end

      context "and the proponent's monthly income is less than 3 times the value of the installment" do
        it 'returns false' do
          age = 51
          monthly_income = 1_999
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be false
        end
      end
    end
  end
end
