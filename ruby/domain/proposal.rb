class Proposal
  attr_reader :id
  attr_accessor :loan_value, :number_of_monthly_installments

  MIN_LOAN_VALUE = 30_000
  MAX_LOAN_VALUE = 3_000_000
  MIN_NUMBER_OF_MONTHLY_INSTALLMENTS = 48
  MAX_NUMBER_OF_MONTHLY_INSTALLMENTS = 180
  MIN_NUMBER_OF_PROPONENTS = 2
  NUMBER_OF_MAIN_PROPONENTS = 1
  MIN_PROPONENT_AGE = 18
  MIN_NUMBER_OF_WARRANTIES = 1
  WARRANTIES_VALUE_MULTIPLIER = 2
  UNACCEPTABLE_PROVINCES = %w[RS SC PR].freeze

  def initialize(id:, loan_value:, number_of_monthly_installments:, proponents: [], warranties: [])
    @id = id
    @loan_value = loan_value
    @number_of_monthly_installments = number_of_monthly_installments
    @proponents = proponents
    @warranties = warranties
  end

  def add_proponent(proponent)
    @proponents << proponent if proponent.age >= MIN_PROPONENT_AGE
    self
  end

  def remove_proponent(proponent)
    @proponents.delete(proponent)
  end

  def add_warranty(warranty)
    @warranties << warranty unless UNACCEPTABLE_PROVINCES.include?(warranty.province)
    self
  end

  def remove_warranty(warranty)
    @warranties.delete(warranty)
  end

  def valid?
    valid_value? &&
      valid_number_of_monthly_installmentas? &&
      valid_proponents? &&
      valid_warranty?
  end

  def proponents
    @proponents.dup
  end

  def warranties
    @warranties.dup
  end

  private

  def installment
    loan_value / number_of_monthly_installments
  end

  def valid_value?
    loan_value >= MIN_LOAN_VALUE &&
      loan_value <= MAX_LOAN_VALUE
  end

  def valid_number_of_monthly_installmentas?
    number_of_monthly_installments >= MIN_NUMBER_OF_MONTHLY_INSTALLMENTS &&
      number_of_monthly_installments <= MAX_NUMBER_OF_MONTHLY_INSTALLMENTS
  end

  def valid_proponents?
    proponents.size >= MIN_NUMBER_OF_PROPONENTS &&
      proponents.select(&:main?).size == NUMBER_OF_MAIN_PROPONENTS &&
      proponents.select(&:main?).first.monthly_income_for?(installment)
  end

  def valid_warranty?
    warranties.size >= MIN_NUMBER_OF_WARRANTIES &&
      warranties.sum(&:value) >= loan_value * WARRANTIES_VALUE_MULTIPLIER
  end

  private_constant :MIN_LOAN_VALUE, :MAX_LOAN_VALUE, :MIN_NUMBER_OF_MONTHLY_INSTALLMENTS,
                   :MAX_NUMBER_OF_MONTHLY_INSTALLMENTS, :MIN_NUMBER_OF_PROPONENTS,
                   :NUMBER_OF_MAIN_PROPONENTS, :MIN_PROPONENT_AGE, :MIN_NUMBER_OF_WARRANTIES,
                   :WARRANTIES_VALUE_MULTIPLIER, :UNACCEPTABLE_PROVINCES
end
