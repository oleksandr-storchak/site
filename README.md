# Tlaquepaque Arts & Shopping Village

Jekyll site for Tlaquepaque Arts & Shopping Village in Sedona, AZ —
showcasing shops, galleries, dining, events, and wedding services.

## Requirements

- Ruby + Bundler
- Node.js (for image optimization, if applicable)

## Getting Started

```bash
bundle install
bundle exec jekyll serve
```

Open http://localhost:4000

## Structure

| Directory | Description |
|-----------|-------------|
| `_shops/` | Retail shop pages (31) |
| `_galleries/` | Art gallery pages (15) |
| `_foods/` | Dining & food pages (9) |
| `_events/` | Event pages |
| `_weddings/` | Wedding venue/service pages |
| `_layouts/` | Page templates |
| `_data/` | Site config, form settings |
| `assets/` | CSS, JS, images |

## Content

Each vendor is a Markdown file with front matter (`title`, `subtitle`, `date`, `slug`, `hours`, etc.).
Images live in `assets/images/` as `.webp` at 480/960/1440px sizes.

## Tech

- Jekyll ~4.3
- `jekyll-seo-tag`, `jekyll-sitemap`
- Vanilla JS (search, calendar, hours, contact form)
- Custom CSS with CSS variables (no framework)

## Deployment

Hosted on GitHub Pages via the built-in Jekyll deployment.

Push to `main` to trigger an automatic build and deploy.

The site is live at: https://activebridge.github.io/tlaq/
