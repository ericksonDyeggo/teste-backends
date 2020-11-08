class Warranty
  attr_reader :id, :proposal_id
  attr_accessor :value, :province

  def initialize(id:, proposal_id:, value:, province:)
    @id = id
    @proposal_id = proposal_id
    @value = value
    @province = province
  end
end
