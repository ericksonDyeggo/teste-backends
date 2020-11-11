class ProposalsRepository
  def initialize(overrides = {})
    @base = overrides.fetch(:base) { [] }
  end

  def add(object)
    base << object
  end

  def get(id)
    base.select { |object| object.id == id }.first
  end

  def all
    base.dup
  end

  def find(&block)
    base.select(&block)
  end

  def remove(object)
    base.delete(object)
  end

  private

  attr_reader :base
end
