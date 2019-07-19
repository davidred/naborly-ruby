module Requests
  module JsonHelpers
    def json
      Oj.load(naborly_client.last_response.body)
    end
  end

  module XmlHelpers
    def xml
      Hash.from_xml(response.body)
    end
  end
end
