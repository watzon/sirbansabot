require "granite/adapter/sqlite"

Granite::Connections << Granite::Adapter::Sqlite.new(name: "sqlite", url: ENV["DATABASE_URL"]? || "sqlite3://./db/database.sqlite")

require "./models/*"
