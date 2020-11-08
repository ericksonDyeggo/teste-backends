class Proposal
  attr_reader :id, :proponents, :warranties
  attr_accessor :loan_value, :number_of_monthly_installments

  MIN_PROPONENT_AGE = 18
  UNACCEPTABLE_PROVINCES = %w[RS SC PR].freeze

  def initialize(id:, loan_value:, number_of_monthly_installments:)
    @id = id
    @loan_value = loan_value
    @number_of_monthly_installments = number_of_monthly_installments
    @proponents = []
    @warranties = []
  end

  def add_proponent(proponent)
    proponents << proponent if proponent.age >= MIN_PROPONENT_AGE
  end

  def add_warranty(warranty)
    warranties << warranty unless UNACCEPTABLE_PROVINCES.include?(warranty.province)
  end

  private_constant :MIN_PROPONENT_AGE, :UNACCEPTABLE_PROVINCES
end
