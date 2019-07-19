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
      let(:complete_application) {
        {
          'applicationId' => '976adde2-65b4-41a2-bc07-5ad2e7a8d2da',
          'personalInformation' => {
              'tenantFirstName' => 'John',
              'tenantMiddleName' => 'Claude',
              'tenantLastName' => 'Doe',
              'aliasFirstName' => 'Jack',
              'aliasMiddleName' => 'Miller',
              'aliasLastName' => 'Cox',
              'phone' => '123-123-1234',
              'monthlyRent' => 1850,
              'hasCoApps' => false,
              'hasDependants' => false,
              'hasPets' => false,
              'crimeCommitted' => false,
              'identityDocuments' => [
                {
                  'attachmentId' => '9eaaec25-17c4-4f26-998d-caa992474b99',
                  'attachmentType' => 'passport'
                }
              ]
          },
          'rentalHistory' => {
            'evicted' => true,
            'evictedExplain' => 'I was one day late in rent payment.',
            'propertyDamage' => true,
            'propertyDamageExplain' => 'One of my guests on their way home bumped into the glass door they did not notice.',
            'addresses' => [
              {
                'location' => {
                  'address' => '45 Argyle Avenue',
                  'unit' => '401',
                  'city' => 'Ottawa',
                  'province' => 'ON',
                  'postal' => 'K2P 1B3',
                  'country' => 'CA'
                },
                'isCurrent' => true,
                'propertyType' => 'condo',
                'totalMonthlyRent' => 1500,
                'monthlyRent' => 1500,
                'rentOwnFamily' => 'rent',
                'rentOwnFamilyExplain' => '',
                'reasonForMoving' => 'other',
                'reasonForMovingExplain' => 'Visit family more often.',
                'startDate' => '10-30-2018',
                'landlord' => {
                  'name' => 'Kevin cox',
                  'contactType' => 'email',
                  'phone' => '',
                  'email' => 'cox@gmail.com',
                  'allowRefCheck' => true
                }
              },
              {
                'location' => {
                  'address' => '451 Argyle Avenue',
                  'unit' => '401',
                  'city' => 'Ottawa',
                  'province' => 'ON',
                  'postal' => 'K2P 1B3',
                  'country' => 'CA'
                },
                'isCurrent' => false,
                'propertyType' => 'condo',
                'totalMonthlyRent' => 0,
                'monthlyRent' => 0,
                'rentOwnFamily' => 'family',
                'rentOwnFamilyExplain' => 'To live with my parents.',
                'reasonForMoving' => 'work_school',
                'reasonForMovingExplain' => '',
                'startDate' => '10-30-2016',
                'endDate' => '10-30-2018'
              },
              {
                'location' => {
                  'address' => '73 leeson street ',
                  'unit' => '',
                  'city' => 'Grand valley',
                  'province' => 'ON',
                  'postal' => 'L9W 5Y8',
                  'country' => 'CA'
                },
                'isCurrent' => false,
                'propertyType' => 'single',
                'totalMonthlyRent' => 1500,
                'monthlyRent' => 1500,
                'rentOwnFamily' => 'rent',
                'rentOwnFamilyExplain' => '',
                'reasonForMoving' => 'better',
                'startDate' => '10-30-2014',
                'endDate' => '10-30-2016',
                'landlord' => {
                  'name' => 'Kelly merrill',
                  'contactType' => 'phone',
                  'phone' => '519-215-6062',
                  'email' => ''
                }
              }
            ]
          },
          "financial" => {
            "incomeSources" => [
              {
                "incomeProviderName" => "Ontario Works",
                "incomeSourceType" => "social",
                "isCurrent" => true,
                "isPrimary" => false,
                "position" => "",
                "incomeType" => "monthly",
                "annualNetIncome" => 12000,
                "startDate" => "01-25-2017",
                'documents' => [
                  {
                    'attachmentId' => '9eaaec25-17c4-4f26-998d-caa992474b99',
                    'attachmentType' => 'pay_stub'
                  }
                ]
              },
              {
                "incomeProviderName" => "AdventureWorks Inc.",
                "incomeSourceType" => "full_time",
                "isCurrent" => true,
                "isPrimary" => true,
                "position" => "Business Development",
                "incomeType" => "salary",
                "monthlyNetIncome" => 3100,
                "location" => {
                  "address" => "7319 21 ave sw",
                  "unit" => "",
                  "city" => "edmonton",
                  "province" => "AB",
                  "postal" => "T6X 1S3",
                  "country" => "CA"
                },
                "startDate" => "05-15-2015",
                "supervisor" => {
                  "name" => "Greg Botbyl",
                  "contactType" => "phone",
                  "phone" => "905-732-7536",
                  "email" => "",
                  "allowRefCheck" => false
                },
                'documents' => [
                  {
                    'attachmentId' => '9eaaec25-17c4-4f26-998d-caa992474b99',
                    'attachmentType' => 'pay_stub'
                  }
                ]
              },
              {
                "incomeProviderName" => "Ontario Pension",
                "incomeSourceType" => "alimony",
                "isCurrent" => false,
                "position" => "",
                "incomeType" => "monthly",
                "annualNetIncome" => 13976,
                "startDate" => "09-19-2012",
                "endDate" => "12-16-2013",
                'documents' => [
                  {
                    'attachmentId' => '9eaaec25-17c4-4f26-998d-caa992474b99',
                    'attachmentType' => 'pay_stub'
                  }
                ]
              }
            ],
            "declaredBankruptcy" => true,
            "declaredBankruptcyExplain" => "I filed for bankrupty in 2017 due to failure to pay all my debts.",
            "healthInsuranceType" => "employer",
            "commuteType" => "other",
            "commuteExplain" => "I commute with my friends for free.",
            "hasVehicles" => true,
            "vehicles" => [
              {
                "typeOfVehicle" => "car",
                "make" => "audi",
                "model" => "4000s",
                "year" => 2016,
                "monthlyPayment" => 750
              }
            ]
          },
          "signature" => "cf3ba574-f745-431b-8a3f-bc251d28ab33"
        }
      }

      it 'raises a not acceptable error when an application is invalid' do
        VCR.use_cassette('validate_incomplete_application') do
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

      it 'successfully validates a complete application' do
        VCR.use_cassette('validate_application', record: :all) do
          naborly_client.validate_application(complete_application)
        end

        expect(naborly_client.last_response.status).to eq(200)
      end
    end
  end
end
