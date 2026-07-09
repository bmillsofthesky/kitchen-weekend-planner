## 1. Model

- [x] 1.1 Add `var potluckUrl: String?` to `MealPlan` in `WeekendPlan.swift`

## 2. PotluckView

- [x] 2.1 Create `KitchenPlanner/Sources/Views/MealPlanning/PotluckView.swift` with:
  - Navigation title "Day N · MealType · Potluck"
  - Hero icon (`person.3.fill`) and heading "This meal is a potluck"
  - `TextField` bound to `mealPlan.potluckUrl` (bridging nil ↔ empty string) with placeholder "Coordination service URL"
  - `Link("Open link", destination: URL)` shown below the field when a valid URL is entered
  - Warm canvas background, earthy orange accent on the icon
- [x] 2.2 Register `PotluckView.swift` in `project.pbxproj`:
  - Add `PBXFileReference` with fileRef ID `CC11DD22EE33FF44AA550011`
  - Add `PBXBuildFile` with buildFile ID `CC11DD22EE33FF44AA550022`
  - Add fileRef to `MealPlanning` group children (alongside `MealView.swift`)
  - Add buildFile to Sources build phase

## 3. Routing

- [x] 3.1 In `PlanOverviewView`, update the `NavigationLink` destination to route to `PotluckView` when `mealPlan.isPotluck`, otherwise `MealView`
