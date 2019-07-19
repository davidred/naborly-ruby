require 'naborly/ruby'
require 'oj'

RSpec.describe Naborly::Ruby::Client::RentalApplications do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_rental_application' do
    xit 'creates a rental application' do
      naborly_client.create_rental_application({
        "landlordEmail" => "landlord@example.com",
        "moveInDate" => "11-21-2020",
        "monthlyRent" => "1850.0",
        "leaseTerm" => 12,
        "tenantEmail" => "tenant@example.com",
        "tenantDateOfBirth" => "01-12-2001",
        "property" => {
            "address" => "1486 Bryant St",
            "unit" => "302",
            "city" => "San Francisco",
            "province" => "CA",
            "postal" => "94107",
            "country" => "US",
            "type" => "condo"
        }
      })

      expect(naborly_client.last_response.status).to eq(201)
      expect(Oj.load(naborly_client.last_response.body)).to eq(hash_including("applicationId"))
    end

    xit 'raises an error when duplicating a rental application' do
      expect {
        naborly_client.create_rental_application({
          "landlordEmail" => "landlord@example.com",
          "moveInDate" => "11-21-2020",
          "monthlyRent" => "1850.0",
          "leaseTerm" => 12,
          "tenantEmail" => "tenant@example.com",
          "tenantDateOfBirth" => "01-12-2001",
          "property" => {
              "address" => "1486 Bryant St",
              "unit" => "302",
              "city" => "San Francisco",
              "province" => "CA",
              "postal" => "94107",
              "country" => "US",
              "type" => "condo"
          }
        })
      }.to raise_error(Naborly::Ruby::ConflictError, 'Code: 409, body: ')
    end
  end

  describe '#get_rental_application_status' do
    xit 'gets the rental application status' do
      naborly_client.get_rental_application_status({
        "applicationId" => "applicationId_here"
      })

      expect(naborly_client.last_response.status).to eq(201)
      expect(Oj.load(naborly_client.last_response.body)).to eq(hash_including({ "status" => "application_created" }))
    end
  end
end
