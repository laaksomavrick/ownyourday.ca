# frozen_string_literal: true

require 'factory_bot'
# rubocop:disable Style/MixinUsage
include FactoryBot::Syntax::Methods
# rubocop:enable Style/MixinUsage

# Create dev user
user = User.create(email: 'dev@example.com', password: 'Qweqwe1!', time_zone: 'America/Toronto')

# Create list of goals for user
daily_goal = create(:daily_goal, user:)
times_per_week_goal = create(:times_per_week_goal, user:)
create(:days_of_week_goal, user:)

# Create milestones for some goals
create(:milestone, goal: daily_goal)
create(:milestone, goal: daily_goal, completed: false, completed_at: false)
create_list(:milestone, 3, goal: times_per_week_goal)

# Create a task list and task for user
GenerateTodaysTaskListAction.new(user:).call
