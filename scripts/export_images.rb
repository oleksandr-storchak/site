#!/usr/bin/env ruby
# Export Active Storage images from Rails to Jekyll assets
# Run from the Rails project root: ruby ../tlaq-jekyll/scripts/export_images.rb

require "sqlite3"
require "fileutils"

RAILS_ROOT = File.expand_path("../../tlaq", __dir__)
DB_PATH = File.join(RAILS_ROOT, "storage", "production.sqlite3")
DB_PATH.replace(File.join(RAILS_ROOT, "storage", "development.sqlite3")) unless File.exist?(DB_PATH)

JEKYLL_ROOT = File.expand_path("..", __dir__)

db = SQLite3::Database.new(DB_PATH)
db.results_as_hash = true

# Map record types to output directories
TYPE_MAP = {
  "Shop" => "stores",
  "Gallery" => "stores",
  "Food" => "stores",
  "Event" => "events",
  "Article" => "articles"
}

attachments = db.execute(<<~SQL)
  SELECT
    a.name AS attachment_name,
    a.record_type,
    a.record_id,
    b.key,
    b.filename,
    b.content_type
  FROM active_storage_attachments a
  JOIN active_storage_blobs b ON a.blob_id = b.id
  WHERE a.record_type IN ('Shop', 'Gallery', 'Food', 'Event', 'Article')
SQL

attachments.each do |att|
  subdir = TYPE_MAP[att["record_type"]]
  next unless subdir

  # Get the record's slug
  table = case att["record_type"]
          when "Shop", "Gallery", "Food" then "stores"
          when "Event" then "events"
          when "Article" then "articles"
          end

  record = db.get_first_row("SELECT slug, title FROM #{table} WHERE id = ?", att["record_id"])
  next unless record

  slug = record["slug"] || record["title"].downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-+$/, "")

  # Determine source path from Active Storage key
  key = att["key"]
  source = File.join(RAILS_ROOT, "storage", key[0..1], key[2..3], key)

  # Determine extension from content_type or filename
  ext = File.extname(att["filename"])
  ext = ".webp" if ext.empty?

  dest_dir = File.join(JEKYLL_ROOT, "assets", "images", subdir)
  FileUtils.mkdir_p(dest_dir)
  dest = File.join(dest_dir, "#{slug}#{ext}")

  if File.exist?(source)
    FileUtils.cp(source, dest)
    puts "Copied: #{source} -> #{dest}"
  else
    puts "MISSING: #{source} (for #{att['record_type']} #{slug})"
  end
end

puts "Done!"
