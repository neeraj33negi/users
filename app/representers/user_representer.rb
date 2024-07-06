class UserRepresenter < ::Representable::Decorator
  include Representable::JSON

  property :name
  property :email
  property :campaigns_list
end
