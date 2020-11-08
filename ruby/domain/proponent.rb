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
end
