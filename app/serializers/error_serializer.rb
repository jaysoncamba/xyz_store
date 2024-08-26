class ErrorSerializer
  include JSONAPI::Serializer
  set_id -> { nil }
  set_type :error
  attributes :message do |error|
    error[:message]
  end
end
