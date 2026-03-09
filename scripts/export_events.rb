#!/usr/bin/env ruby
# Export events from Rails SQLite database to Jekyll collection files
# Run from the Rails project root: ruby ../tlaq-jekyll/scripts/export_events.rb

require "sqlite3"
require "fileutils"
require "yaml"

DB_PATH = File.expand_path("../../tlaq/storage/production.sqlite3", __dir__)
# Fallback to development db
unless File.exist?(DB_PATH)
  DB_PATH.replace(File.expand_path("../../tlaq/storage/development.sqlite3", __dir__))
end

OUTPUT_DIR = File.expand_path("../_events", __dir__)
FileUtils.mkdir_p(OUTPUT_DIR)

db = SQLite3::Database.new(DB_PATH)
db.results_as_hash = true

events = db.execute("SELECT * FROM events ORDER BY starts_at ASC")

events.each do |event|
  slug = event["slug"] || event["title"].downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-+$/, "")
  filename = File.join(OUTPUT_DIR, "#{slug}.md")

  # Get ActionText content
  rich_text = db.get_first_row(
    "SELECT body FROM action_text_rich_texts WHERE record_type = 'Event' AND record_id = ? AND name = 'description'",
    event["id"]
  )

  front_matter = {
    "title" => event["title"],
    "slug" => slug,
    "starts_at" => event["starts_at"],
    "ends_at" => event["ends_at"],
    "location" => event["location"],
    "phone" => event["phone"],
    "email" => event["email"],
    "website" => event["website"],
    "facebook" => event["facebook"],
    "instagram" => event["instagram"],
    "annual" => event["annual"] == 1,
    "image" => "/assets/images/events/#{slug}.webp"
  }.compact.reject { |_, v| v.nil? || v == "" || v == false }

  # Add subtitle if present
  front_matter["subtitle"] = event["subtitle"] if event["subtitle"] && !event["subtitle"].empty?

  content = rich_text ? rich_text["body"].to_s : ""

  File.write(filename, "#{front_matter.to_yaml}---\n#{content}\n")
  puts "Created: #{filename}"
end

puts "Exported #{events.size} events"
