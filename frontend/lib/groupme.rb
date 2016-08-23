require 'rest-client'
require 'json'

module GroupMe
    def GroupMe.send(inbound_sender, payload, bot_id)
        GroupMe.broadcast(payload, bot_id)
    end
    def GroupMe.broadcast(payload, bot_id)
        if ENV['RACK_ENV'].eql?('production')
            resp = Hash.new
            resp['bot_id'] = bot_id
            resp['text'] = payload
            outbound_payload = resp.to_json
            return RestClient.post('https://api.groupme.com/v3/bots/post', outbound_payload, :content_type => :json)
        else
            puts "GroupMe broadcast restrained. To use, re-run with RACK_ENV set to 'production'."
        end
    end
end