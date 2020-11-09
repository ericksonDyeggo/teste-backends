class Proponent
  attr_reader :id, :proposal_id
  attr_accessor :name, :age, :monthly_income, :main

  def initialize(id:, proposal_id:, name:, age:, monthly_income:, main:)
    @id = id
    @proposal_id = proposal_id
    @name = name
    @age = age
    @monthly_income = monthly_income
    @main = main
  end

  def main?
    main
  end

  def monthly_income_for?(installment)
    monthly_income >= (installment * installment_multiplier)
  end

  private

  def installment_multiplier
    case age
    when 18..23
      4
    when 24..50
      3
    else
      2
    end
  end
end
