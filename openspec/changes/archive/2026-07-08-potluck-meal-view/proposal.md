## Why

When a meal is marked as a potluck, the standard Recipes/Theme view is irrelevant — there are no recipes to assign and no meal to theme. Showing the normal planning interface creates confusion. A dedicated potluck view makes the intent clear and gives the planner a place to store the link to whatever potluck coordination service the group uses (e.g., SignUpGenius, PotluckPlanner).

## What Changes

- Add `potluckUrl: String?` to `MealPlan` for storing a link to a potluck coordination service
- When navigating to a meal that `isPotluck`, show a new `PotluckView` instead of the standard `MealView` recipe/theme tabs
- `PotluckView` explains the meal is a potluck and lets the user enter/edit a URL to a coordination service, displayed as a tappable link

## Capabilities

### New Capabilities
- `potluck-coordination`: A dedicated potluck meal screen with coordination link support

### Modified Capabilities
- `meal-planning`: Navigation to a potluck meal now shows a different view

## Impact

- `WeekendPlan.swift` — add `potluckUrl: String?` to `MealPlan`
- New `PotluckView.swift` — the dedicated potluck screen
- `PlanOverviewView.swift` — `NavigationLink` to a meal checks `isPotluck` and routes to `PotluckView` or `MealView` accordingly
- `project.pbxproj` — register `PotluckView.swift`
