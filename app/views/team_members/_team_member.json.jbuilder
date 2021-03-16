json.extract! team_member, :id, :name, :email, :phone, :created_at, :updated_at
json.url team_member_url(team_member, format: :json)
