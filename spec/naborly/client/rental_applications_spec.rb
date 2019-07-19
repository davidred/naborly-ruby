require 'naborly/ruby'
require 'oj'

RSpec.describe Naborly::Ruby::Client::RentalApplications do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_rental_application' do
    it 'creates a rental application' do
      naborly_client.create_rental_application({
        "landlordEmail" => "landlord+1@example.com",
        "moveInDate" => "11-21-2020",
        "monthlyRent" => "1850.0",
        "leaseTerm" => 12,
        "tenantEmail" => "tenant+5@example.com",
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
      expect(Oj.load(naborly_client.last_response.body)["applicationId"]).to_not be_empty
    end

    it 'raises a not acceptable error when creating a rental application for an existing tenant' do
      expect {
        naborly_client.create_rental_application({
          "landlordEmail" => "landlord+1@example.com",
          "moveInDate" => "11-21-2020",
          "monthlyRent" => "1850.0",
          "leaseTerm" => 12,
          "tenantEmail" => "tenant+5@example.com",
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
      }.to raise_error(Naborly::Ruby::NotAcceptableError, 'Code: 406, body: ')
    end
  end

  describe '#get_rental_application_status' do
    it 'gets the rental application status' do
      naborly_client.get_rental_application_status({
        "applicationId" => "976adde2-65b4-41a2-bc07-5ad2e7a8d2da"
      })

      expect(naborly_client.last_response.status).to eq(200)
      expect(Oj.load(naborly_client.last_response.body)).to eq({ "status" => "application_created" })
    end
  end
end
