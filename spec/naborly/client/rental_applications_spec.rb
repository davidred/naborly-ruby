require 'naborly/ruby'
require 'oj'
require 'pry'

RSpec.describe Naborly::Ruby::Client::RentalApplications do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_rental_application' do
    it 'creates a rental application' do
      VCR.use_cassette('create_rental_application') do
        naborly_client.create_rental_application({
          "landlordEmail" => "landlord+1@example.com",
          "moveInDate" => "11-21-2020",
          "monthlyRent" => "1850.0",
          "leaseTerm" => 12,
          "tenantEmail" => "tenant+99@example.com",
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
      end

      expect(naborly_client.last_response.status).to eq(201)
      expect(Oj.load(naborly_client.last_response.body)["applicationId"]).to_not be_empty
    end

    it 'raises a not acceptable error when creating a rental application for an existing tenant' do
      VCR.use_cassette('create_existing_rental_application') do
        expect {
          naborly_client.create_rental_application({
            "landlordEmail" => "landlord+1@example.com",
            "moveInDate" => "11-21-2020",
            "monthlyRent" => "1850.0",
            "leaseTerm" => 12,
            "tenantEmail" => "tenant+99@example.com",
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
        }.to raise_error(Naborly::Ruby::NotAcceptableError, 'Code: 406')
      end
    end
  end

  describe '#get_rental_application_status' do
    it 'gets the rental application status' do
      VCR.use_cassette('get_rental_application_status') do
        naborly_client.get_rental_application_status({
          'applicationId' => '976adde2-65b4-41a2-bc07-5ad2e7a8d2da'
        })
      end

      expect(naborly_client.last_response.status).to eq(200)
      expect(Oj.load(naborly_client.last_response.body)).to eq({ 'status' => 'application_created' })
    end
  end

  describe '#attach_file' do
    it 'attaches a file' do
      VCR.use_cassette('attach_file') do
        naborly_client.attach_file({
          'applicationId' => '976adde2-65b4-41a2-bc07-5ad2e7a8d2da',
          file: File.open('./spec/fixtures/files/walrus.jpg')
        })
      end

      expect(naborly_client.last_response.status).to eq(201)
      expect(json['attachmentId']).not_to be_empty
      expect(json['preview']).not_to be_empty
    end

    it 'raises a not acceptable error when an incorrect application id is provided' do
      VCR.use_cassette('attach_file_to_nonexistent_application') do
        expect {
          naborly_client.attach_file({
            'applicationId' => 'bogus',
            file: File.open('./spec/fixtures/files/walrus.jpg')
          })
        }.to raise_error(Naborly::Ruby::NotAcceptableError, 'Code: 406')
      end
    end

    describe '#validate_application' do
      it 'updates an application' do
        VCR.use_cassette('validate_application') do
          expect {
            naborly_client.validate_application({
              'applicationId' => '976adde2-65b4-41a2-bc07-5ad2e7a8d2da',
              'personalInformation' => {
                  'tenantFirstName' => 'John',
                  'tenantMiddleName' => 'Claude',
                  'tenantLastName' => 'Doe',
                  'aliasFirstName' => 'Jack',
                  'aliasMiddleName' => 'Miller',
                  'aliasLastName' => 'Cox',
                  'phone' => '',
                  'monthlyRent' => 1850
              }
            })
          }.to raise_error(Naborly::Ruby::NotAcceptableError, 'Code: 406, message: Application data validation failed')
        end

        expect(json['message']).to eq('Application data validation failed')
        expect(json['errors']).to include(hash_including("message", "path", "type", "context"))
      end
    end
  end
end
