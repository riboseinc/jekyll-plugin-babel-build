Jekyll::Hooks.register :site, :post_write do |site|
  build_js(site.config['destination'] || '_site')
end

def build_js(site_dest)

  # Copy Babel polyfills
  system("cp node_modules/@babel/polyfill/dist/polyfill.min.js #{site_dest}/assets/js/babel-polyfill.js")

  # Transpile JS assets
  system("./node_modules/.bin/babel #{site_dest}/assets/js --out-dir #{site_dest}/assets/js")

end
