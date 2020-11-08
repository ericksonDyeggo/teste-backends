class Proposal
  attr_reader :id
  attr_accessor :loan_value, :number_of_monthly_installments

  def initialize(id:, loan_value:, number_of_monthly_installments:)
    @id = id
    @loan_value = loan_value
    @number_of_monthly_installments = number_of_monthly_installments
  end
end
