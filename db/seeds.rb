# frozen_string_literal: true

require 'factory_bot'
# rubocop:disable Style/MixinUsage
include FactoryBot::Syntax::Methods
# rubocop:enable Style/MixinUsage

# Create dev user
user = User.create(email: 'dev@example.com', password: 'Qweqwe1!', time_zone: 'America/Toronto')

# Create list of goals for user
create(:daily_goal, user:)
create(:times_per_week_goal, user:)
create(:days_of_week_goal, user:)

# Create a task list and task for user
GenerateTodaysTaskListAction.new(user:).call
