class AuthorSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :middle_name
end
