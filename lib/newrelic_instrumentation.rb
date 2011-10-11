require 'new_relic/agent/method_tracer'

Drop.instance_eval do
  class << self
    include NewRelic::Agent::MethodTracer
    add_method_tracer :find, 'Custom/Drop/find'
  end
end

Thumbnail.class_eval do
  include NewRelic::Agent::MethodTracer

  add_method_tracer :file
  add_method_tracer :image
  add_method_tracer :resize_image
  add_method_tracer :image_too_large?
  add_method_tracer :tempfile
end
