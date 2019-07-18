require 'active_support/hash_with_indifferent_access'

module Naborly
  module Ruby
    module ApiSubusers
      API_PATH = '/v1/addAPISubuser'.freeze

      attr_reader :landlord_first_name, :landlord_last_name, :landlord_company, :landlord_phone, :landlord_email

      def add_api_subuser(args = {})
        res
      end

      # def initialize(attrs = {})
      #   attrs = HashWithIndifferentAccess.new(attrs)
      #   @landlord_first_name = attrs[:landlordFirstName]
      #   @landlord_last_name = attrs[:landlord_last_name]
      #   @landlord_company = attrs[:landlord_company]
      #   @landlord_phone = attrs[:landlord_phone]
      #   @landlord_email = attrs[:landlord_email]
      # end
    end
  end
end
