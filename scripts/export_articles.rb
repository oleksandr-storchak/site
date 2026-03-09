#!/usr/bin/env ruby
# Export articles from Rails SQLite database to Jekyll collection files
# Run from the Rails project root: ruby ../tlaq-jekyll/scripts/export_articles.rb

require "sqlite3"
require "fileutils"
require "yaml"

DB_PATH = File.expand_path("../../tlaq/storage/production.sqlite3", __dir__)
unless File.exist?(DB_PATH)
  DB_PATH.replace(File.expand_path("../../tlaq/storage/development.sqlite3", __dir__))
end

OUTPUT_DIR = File.expand_path("../_articles", __dir__)
FileUtils.mkdir_p(OUTPUT_DIR)

db = SQLite3::Database.new(DB_PATH)
db.results_as_hash = true

articles = db.execute("SELECT * FROM articles ORDER BY published_at DESC")

articles.each do |article|
  slug = article["slug"] || article["title"].downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-+$/, "")
  filename = File.join(OUTPUT_DIR, "#{slug}.md")

  # Get ActionText content
  rich_text = db.get_first_row(
    "SELECT body FROM action_text_rich_texts WHERE record_type = 'Article' AND record_id = ? AND name = 'content'",
    article["id"]
  )

  front_matter = {
    "title" => article["title"],
    "slug" => slug,
    "author" => article["author"],
    "published_at" => article["published_at"],
    "thumbnail" => "/assets/images/articles/#{slug}.webp"
  }.compact.reject { |_, v| v.nil? || v == "" }

  content = rich_text ? rich_text["body"].to_s : ""

  File.write(filename, "#{front_matter.to_yaml}---\n#{content}\n")
  puts "Created: #{filename}"
end

puts "Exported #{articles.size} articles"
