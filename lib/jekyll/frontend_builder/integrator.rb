# frozen_string_literal: true

# (c) Copyright 2021 Ribose Inc.
#

module Jekyll
  module FrontendBuilder
    module Integrator
      module_function

      def register_hook
        Jekyll::Hooks.register :site, :post_write, &method(:process_site)
      end

      def process_site(site)
        Processor.new(site).process_site
      end
    end
  end
end
