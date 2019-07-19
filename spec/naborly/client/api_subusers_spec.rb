require 'naborly/ruby'

RSpec.describe Naborly::Ruby::Client::ApiSubusers do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_api_subuser' do
    it 'creates an api subuser' do
      naborly_client.create_api_subuser({
        "landlordFirstName" => "Jane",
        "landlordLastName" => "Doe",
        "landlordCompany" => "Jane Doe Inc.",
        "landlordPhone" => "123-123-1234",
        "landlordEmail" => "landlord3@example.com"
      })

      expect(naborly_client.last_response.status).to eq(201)
    end

    it 'raises an error when duplicating an api subuser' do
      expect {
        naborly_client.create_api_subuser({
          "landlordFirstName" => "Jane",
          "landlordLastName" => "Doe",
          "landlordCompany" => "Jane Doe Inc.",
          "landlordPhone" => "123-123-1234",
          "landlordEmail" => "landlord@example.com"
        })
      }.to raise_error(Naborly::Ruby::ConflictError, 'Code: 409, body: ')
    end
  end
end
