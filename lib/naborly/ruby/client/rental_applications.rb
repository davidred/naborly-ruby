module Naborly
  module Ruby
    class Client
      module RentalApplications
        CREATE_RENTAL_APPLICATION_PATH = 'https://sandbox.api.naborly.com/v1/requestApplication'.freeze
        GET_RENTAL_APPLICATION_STATUS_PATH = 'https://sandbox.api.naborly.com/v1/checkApplicationStatus'.freeze

        attr_reader :landlord_first_name, :landlord_last_name, :landlord_company, :landlord_phone, :landlord_email

        def create_rental_application(body = {})
          request(http_method: :post, endpoint: CREATE_RENTAL_APPLICATION_PATH, body: body)
        end

        def get_rental_application_status(body = {})
          request(http_method: :post, endpoint: GET_RENTAL_APPLICATION_STATUS_PATH, body: body)
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
end
