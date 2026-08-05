require "fileutils"

Jekyll::Hooks.register :site, :post_write do |site|
  icon_mappings = [
    ["assets/img/favicon.ico", "favicon.ico"],
    ["assets/img/apple-touch-icon.png", "apple-touch-icon.png"],
    ["assets/img/apple-touch-icon.png", "apple-touch-icon-precomposed.png"]
  ]

  icon_mappings.each do |source_path, destination_path|
    source = File.join(site.source, source_path)
    destination = File.join(site.dest, destination_path)

    next unless File.exist?(source)

    FileUtils.cp(source, destination)
  end
end
