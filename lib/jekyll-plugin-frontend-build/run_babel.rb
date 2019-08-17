Jekyll::Hooks.register :site, :post_write do |site|
  run_frontend_build()
end

def run_frontend_build()
  system('./node_modules/.bin/babel assets/js --out-dir _site/assets/js')
end
