#!/usr/bin/env ruby
require "yaml"
require "fileutils"

STORES_YML = File.expand_path("../../tlaq/db/stores.yml", __dir__)
JEKYLL_ROOT = File.expand_path("..", __dir__)

TYPE_MAP = {
  "Shop" => "_shops",
  "Gallery" => "_galleries",
  "Food" => "_foods"
}

stores = YAML.load_file(STORES_YML)

stores.each do |store|
  type_dir = TYPE_MAP[store["type"]]
  next unless type_dir

  slug = store["title"]
    .downcase
    .gsub(/[''"]/, "")
    .gsub(/[^a-z0-9]+/, "-")
    .gsub(/^-|-$/, "")

  dir = File.join(JEKYLL_ROOT, type_dir)
  FileUtils.mkdir_p(dir)

  front_matter = { "slug" => slug }
  front_matter["title"] = store["title"]
  front_matter["subtitle"] = store["subtitle"] if store["subtitle"]
  front_matter["suite"] = store["suite"] if store["suite"]
  front_matter["phone"] = store["phone"] if store["phone"]
  front_matter["website"] = store["website"] if store["website"]
  front_matter["facebook"] = store["facebook"] if store["facebook"]
  front_matter["instagram"] = store["instagram"] if store["instagram"]
  front_matter["coordinates"] = store["coordinates"] if store["coordinates"]
  front_matter["image"] = "/assets/images/stores/#{slug}.webp"

  if store["store_hours"]
    front_matter["store_hours"] = store["store_hours"]
  end

  body = store["body"] || ""

  filename = File.join(dir, "#{slug}.md")
  File.write(filename, "#{front_matter.to_yaml}---\n#{body}\n")
  puts "#{type_dir}/#{slug}.md"
end

puts "\nDone! Created #{stores.size} store files."
