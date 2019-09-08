# Create the database file if it doesn't exist
if [ ! -f db/database.sqlite ]; then
    touch db/database.sqlite
fi

# Install shards
shards install

# Run migrations
bin/micrate up

# Build the bot
shards build sirbansabot --release

# Run it
bin/sirbansabot