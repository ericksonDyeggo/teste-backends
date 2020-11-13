require 'date'
require_relative '../domain/proposals_repository'
require_relative '../use_cases/create_proposal'
require_relative '../use_cases/update_proposal'
require_relative '../use_cases/delete_proposal'
require_relative '../use_cases/add_proponent'
require_relative '../use_cases/update_proponent'
require_relative '../use_cases/remove_proponent'
require_relative '../use_cases/add_warranty'
require_relative '../use_cases/update_warranty'
require_relative '../use_cases/remove_warranty'

class MessageProcessor
  def initialize(overrides = {})
    @processed_messages = overrides.fetch(:processed_messages) { [] }
    @proposals_repository = overrides.fetch(:proposals_repository) { ProposalsRepository.new }
  end

  def process(messages)
    messages.each do |message|
      event_id, event_schema, event_action, event_timestamp_string, *args = message.split(',')
      event_timestamp = DateTime.parse(event_timestamp_string)
      use_case = use_case_for(event_schema, event_action)
      next unless process_message?(event_id, event_schema, event_action, event_timestamp, args)

      use_case.call(*args)
      @processed_messages << { id: event_id, schema: event_schema, action: event_action,
                               timestamp: event_timestamp, args: args }
    end

    @proposals_repository.find(&:valid?).map(&:id).compact.join(',')
  end

  private

  def process_message?(event_id, event_schema, event_action, event_timestamp, args)
    @processed_messages.none? do |message|
      message[:id] == event_id ||
        message[:schema] == event_schema &&
          message[:action] == event_action &&
          event_action == 'updated' &&
          message[:timestamp] >= event_timestamp &&
          message[:args][1] == args[1]
    end
  end

  # rubocop:disable Metrics/MethodLength
  def use_case_for(event_schema, event_action)
    {
      proposal: {
        created: CreateProposal.new(proposals_repository: @proposals_repository),
        updated: UpdateProposal.new(proposals_repository: @proposals_repository),
        deleted: DeleteProposal.new(proposals_repository: @proposals_repository)
      },
      proponent: {
        added: AddProponent.new(proposals_repository: @proposals_repository),
        updated: UpdateProponent.new(proposals_repository: @proposals_repository),
        removed: RemoveProponent.new(proposals_repository: @proposals_repository)
      },
      warranty: {
        added: AddWarranty.new(proposals_repository: @proposals_repository),
        updated: UpdateWarranty.new(proposals_repository: @proposals_repository),
        removed: RemoveWarranty.new(proposals_repository: @proposals_repository)
      }
    }.dig(event_schema.to_sym, event_action.to_sym)
  end
  # rubocop:enable Metrics/MethodLength
end
