class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :username, :email, :role_id, :created_at
end
