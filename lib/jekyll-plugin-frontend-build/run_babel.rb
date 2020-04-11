require 'fileutils'


$GEM_PATH = File.expand_path '../../..', __FILE__
$NODE_MODULES = "#{$GEM_PATH}/node_modules"
$NODE_BIN = "#{$NODE_MODULES}/.bin"
$SITE_JS_PATH = "assets/js"
$DEFAULT_SITE_DEST = "_site"
$CFG_KEY = "_frontend_components"

Jekyll::Hooks.register :site, :after_init do |site|
  Dir.chdir($GEM_PATH) {
    system("npm install")
  }
end


Jekyll::Hooks.register :site, :post_write do |site|
  dest = site.config['destination'] || $DEFAULT_SITE_DEST
  frontend_components = site.config[$CFG_KEY] || {}

  write_react_hydration(frontend_components, "#{site.source}/#{$SITE_JS_PATH}")
  build_js(dest)
  bundle_react_hydration("#{site.source}/#{$SITE_JS_PATH}")
end


def write_react_hydration(component_config, source_app_root)
  preamble = "
    import ReactDOM from 'react-dom';
  "
  imports = []
  hydrations = []
  component_config.each do |component_path, container_id|
    imports << "
      import { Component as Component_#{container_id} } from '#{component_path}';
    "
    hydrations << "
      const containerEl = document.querySelector(`#${container_id}`);
      ReactDOM.hydrate(<Component_#{container_id} />, containerEl);
    "
  end
  File.open("#{source_app_root}/__react_render.jsx", 'w') { |file|
    file.write("
      #{preamble}

      #{imports.join('
      ')}

      #{hydrations.join('
      ')}
    ")
  }
end

def bundle_react_hydration(built_app_root)
  File.open("#{built_app_root}/webpack.config.js", 'w') { |file|
    file.write("
      module.exports = {
        entry: {
          index: '#{built_app_root}/__react_render.js'
        },
        output: {
          filename: 'main.js',
          path: '#{built_app_root}'
        }
      };
    ")
  }

  Dir.chdir($GEM_PATH) {
    system("#{$NODE_BIN}/webpack --config #{built_app_root}/webpack.config.js")
  }
end

def build_js(site_dest)
  Dir.chdir($GEM_PATH) {

    # Copy Babel polyfills
    system("cp node_modules/@babel/polyfill/dist/polyfill.min.js #{site_dest}/assets/js/babel-polyfill.js")

    # Transpile JS assets
    system("./node_modules/babel #{site_dest}/#{$SITE_JS_PATH} -x .js --out-dir #{site_dest}/#{$SITE_JS_PATH}")

  }
end

def make_container_id()
  (0...6).map { ('a'..'z').to_a[rand(26)] }.join
end

module Jekyll
  class RenderReactTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text

      tokens = text.strip().gsub(/\s+/m, ' ').strip.split(' ')
      @component_module = tokens[0]
    end

    def render(context)
      @site_root = context.registers[:site].source
      @site_dest = context.registers[:site].config['destination'] || $DEFAULT_SITE_DEST

      container_id = make_container_id()

      @component_path = "#{@site_root}/#{$SITE_JS_PATH}/#{@component_module}"
      @frontend_component_path = "/#{$SITE_JS_PATH}/#{@component_module}"

      # NOTE: Per-page bundles?
      # page_id = context.registers[:page].id

      context.registers[:site].config[$CFG_KEY] ||= {}
      context.registers[:site].config[$CFG_KEY][@frontend_component_path] = container_id

      `#{$NODE_BIN}/babel-node #{$GEM_PATH}/render-react.js #{@component_path} #{container_id}`
    end
  end
end

Liquid::Template.register_tag('render_react', Jekyll::RenderReactTag)