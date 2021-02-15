# frozen_string_literal: true

# (c) Copyright 2021 Ribose Inc.
#

require_relative "frontend_builder/integrator"
require_relative "frontend_builder/processor"
require_relative "frontend_builder/version"

module Jekyll
  module FrontendBuilder
  end
end

Jekyll::FrontendBuilder::Integrator.register_hook
