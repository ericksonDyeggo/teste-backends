class Proposal
  attr_reader :id, :proponents
  attr_accessor :loan_value, :number_of_monthly_installments

  def initialize(id:, loan_value:, number_of_monthly_installments:)
    @id = id
    @loan_value = loan_value
    @number_of_monthly_installments = number_of_monthly_installments
    @proponents = []
  end

  def add_proponent(proponent)
    proponents << proponent if proponent.age >= MIN_PROPONENT_AGE
  end

  private

  MIN_PROPONENT_AGE = 18
end
