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
  JSON.parse(resp.body)
end

def create_deal(client_id, stage_id, name, cost)
  resp = @conn.post('/api/shared/v1/deals') do |req|
    req.headers['Authorization'] = "#{@token_type} #{@access_token}"
    req.body = {
      deal: {
        name: name,
        client_id: client_id,
        stage_id: stage_id,
        cost: cost
      }
    }.to_json
  end
  puts resp.body.inspect
  JSON.parse(resp.body)['data']['id']
end

def create_message(deal_id, content)
  @conn.post('/api/shared/v1/messages') do |req|
    req.headers['Authorization'] = "#{@token_type} #{@access_token}"
    req.body = {
      message: {
        entity_type: 'Deal',
        entity_id: deal_id,
        content: content
      }
    }.to_json
  end
end

token_resp = get_access_token()

@access_token = token_resp['access_token']
@token_type = token_resp['token_type']
@refresh_token = token_resp['refresh_token']

name = 'Тестовая сделка'
cost = 0
client_id = 'Замените на необходимый ID клиента'
stage_id = 'Замените на необходимый ID этапа сделки'
deal_id = create_deal(client_id, stage_id, name, cost)

message_content = 'Текст сообщения'
create_message(deal_id, message_content)