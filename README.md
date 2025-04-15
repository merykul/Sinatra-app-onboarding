# Sinatra-app-onboarding

#### To run application locally: `rackup config.ru`

#### preconditions:
1. Install homebrew: https://mac.install.guide/homebrew/3
2. Install rvm and ruby: https://www.notion.so/Installing-RVM-55a5e68cf11b469a9a85e0f947657dea
3. Run: `bundle install`
4. Start mysql server:

`brew services start mysql`

`mysql_config --socket` (Check Socket File Location)

`mysqladmin ping` (verifies if mysqladmin is running)
5. Create the database: `rake db:create`
6. Migrate the database: `rake db:migrate`
7. Seed the test data: `rake db:seed`
