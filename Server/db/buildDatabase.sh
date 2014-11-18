echo "Initializing database..."
rake db:schema:load
echo "Clearing database..."
rake db:reset
echo "Seeding database..."
rake db:seed:courseSeeds
rake db:seed:sectionSeeds
echo "Please restart the server..."