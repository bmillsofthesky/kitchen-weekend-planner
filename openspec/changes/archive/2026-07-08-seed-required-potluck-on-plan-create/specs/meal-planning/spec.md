## MODIFIED Requirements

### Requirement: MealConfig supports required-potluck designation
`MealConfig` SHALL include a `potluckRequired` boolean field (default `false`). When `potluckRequired` is `true`, the meal SHALL be treated as a potluck unconditionally — the user toggle SHALL be hidden, `MealPlan.isPotluck` SHALL be set to `true` automatically, and `MealPlan.isPotluck` SHALL be initialized to `true` at plan creation time so the Plan Overview reflects the potluck state immediately.

#### Scenario: Required-potluck meal is initialized as potluck at plan creation
- **WHEN** a new weekend plan is created for a movement that has `potluckRequired: true` on a meal
- **THEN** the corresponding `MealPlan.isPotluck` SHALL be `true` immediately, without requiring the user to open the meal first

#### Scenario: Required-potluck meal is auto-set on view
- **WHEN** a user opens a meal whose config has `potluckRequired: true`
- **THEN** `MealPlan.isPotluck` SHALL be `true` and no potluck toggle SHALL be shown

#### Scenario: Required-potluck meal shows potluck badge on card
- **WHEN** a required-potluck meal is displayed in the Plan overview
- **THEN** the potluck badge SHALL appear on the card immediately after plan creation

#### Scenario: Non-required meals are unaffected
- **WHEN** a meal's config has `potluckRequired: false` (or the field is absent)
- **THEN** existing potluck-eligible toggle behavior SHALL be unchanged

#### Scenario: Existing movement configs decode without error
- **WHEN** a movement JSON config does not include `potluckRequired`
- **THEN** the field SHALL default to `false` and the meal SHALL behave as before
