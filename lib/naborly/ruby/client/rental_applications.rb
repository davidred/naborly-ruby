module Naborly
  module Ruby
    class Client
      module RentalApplications
        CREATE_RENTAL_APPLICATION_PATH = '/v1/requestApplication'.freeze
        GET_RENTAL_APPLICATION_STATUS_PATH = '/v1/checkApplicationStatus'.freeze
        ATTACH_FILE_PATH = '/v1/attachFile'.freeze
        VALIDATE_RENTAL_APPLICATION_PATH = '/v1/validateApplication'.freeze

        attr_reader :landlord_first_name, :landlord_last_name, :landlord_company, :landlord_phone, :landlord_email

        def create_rental_application(body = {})
          request(http_method: :post, path: CREATE_RENTAL_APPLICATION_PATH, body: body.to_json)
        end

        def get_rental_application_status(body = {})
          request(http_method: :post, path: GET_RENTAL_APPLICATION_STATUS_PATH, body: body.to_json)
        end

        def attach_file(body = {})
          request(http_method: :put, path: ATTACH_FILE_PATH, body: body)
        end

        def validate_application(body = {})
          request(http_method: :post, path: VALIDATE_RENTAL_APPLICATION_PATH, body: body.to_json)
        end
      end
    end
  end
end
