require 'active_model_serializers'
require 'rapidfire/routes'

module Rapidfire
  class Engine < ::Rails::Engine
    isolate_namespace Rapidfire
  end
end
