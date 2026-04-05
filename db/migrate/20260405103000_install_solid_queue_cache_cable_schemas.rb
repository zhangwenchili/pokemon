# frozen_string_literal: true

# Heroku (and any setup where primary, queue, cache, and cable share one DATABASE_URL):
# `db:prepare` skips loading db/*_schema.rb for non-primary configs once schema_migrations exists,
# so Solid Queue / Solid Cache / Solid Cable tables never get created. Load them from the schema
# files when missing (see solid_queue README "Single database configuration").
class InstallSolidQueueCacheCableSchemas < ActiveRecord::Migration[8.1]
  def up
    load_schema_file("db/queue_schema.rb") unless table_exists?(:solid_queue_jobs)
    load_schema_file("db/cache_schema.rb") unless table_exists?(:solid_cache_entries)
    load_schema_file("db/cable_schema.rb") unless table_exists?(:solid_cable_messages)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def load_schema_file(relative_path)
    load Rails.root.join(relative_path)
  end
end
