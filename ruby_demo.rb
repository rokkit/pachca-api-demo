require 'faraday'
require 'json'
require 'net/http'
require 'uri'

url = 'https://api.pachca.com'

@conn = Faraday.new(
  url: url,
  headers: { 'Content-Type' => 'application/json' }
)

@creds = {
  client_id: '',
  client_secret: '',
  code: '',
  grant_type: 'authorization_code',
  redirect_uri: 'https://app.pachca.com/'
}

def get_access_token
  resp = @conn.post('/api/shared/v1/oauth/token') do |req|
    req.body = @creds.to_json
  end
  puts JSON.parse(resp.body)
  JSON.parse(resp.body)
end

def create_deal(client_id, stage_id, name, cost)
  resp = @conn.post('/api/shared/v1/deals') do |req|
    req.headers['Authorization'] = "Bearer #{@access_token}"
    req.body = {
      deal: {
        name: "name2",
        stage_id: stage_id,
        cost: 0,
        note: { content: "first line\nsecondline" },
        responsible_user_ids: [8]
      }
    }.to_json
  end
  puts resp.body.inspect
  JSON.parse(resp.body)['data']['id']
end

def update_deal(deal_id, name)
  resp = @conn.put("/api/shared/v1/deals/#{deal_id}") do |req|
    req.headers['Authorization'] = "Bearer #{@access_token}"
    req.body = {
      deal: {
        custom_properties: [{
          id: 9247,
          value: 1
        }]
      }
    }.to_json
  end
  puts resp.body.inspect
  JSON.parse(resp.body)['data']['id']
end

def create_message(deal_id, content)
  @conn.post('/api/shared/v1/messages') do |req|
    req.headers['Authorization'] = "Bearer #{@access_token}"
    req.body = {
      message: {
        entity_type: 'Deal',
        entity_id: deal_id,
        content: content
      }
    }.to_json
  end
end

# token_resp = get_access_token()
token_resp = {"access_token"=>"Token", "token_type"=>"Bearer", "expires_in"=>7199, "refresh_token"=>"KsKxmC57_otaTogy1F3Y-4A00Z5tXAeyHZdSGFfZsP8", "scope"=>"all", "created_at"=>1642364265}

@access_token = token_resp['access_token']
@token_type = token_resp['token_type']
@refresh_token = token_resp['refresh_token']

name = 'Тестовая сделка'
cost = 0
client_id = '138'
stage_id = '97001'
# deal_id = create_deal(client_id, stage_id, name, cost)
update_deal(2510909, "Hello")

# message_content = 'Текст сообщения'
# create_message(deal_id, message_content)