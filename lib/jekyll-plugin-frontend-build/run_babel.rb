Jekyll::Hooks.register :site, :post_write do |site|
  build_js()
end

def build_js()

  # Transpile JS assets
  system('./node_modules/.bin/babel _site/assets/js --out-dir _site/assets/js')

end
