# 3-Day Weekend Kitchen Planner

For a 3-Day Christian Retreat Weekends (ex. Tres Dias and Vida Nueva), there is a kitchen team that in order to prepare for the weekend, they are responsible for developing a menu and themes for every meal. Weekends can be any number of days, usually 3.

This IOS app, built with Swift UI, will allow the kitchen teams to develop the meals for the weekend. It will provide the ability to select from different pre-loaded recipes to build out each meal's menu. It will also allow for areas to describe themes and decorations needed for those meals.

This should be a simple app that is mostly drag and drop recipes into meal slots and some interactive sections to design themes. It should have the ability to import links from Amazon and other websites to describe items needed for the meal theme.

The ultimate goal of the product is to provide an interactive way for the kitchen team to develop the meals and export them into a well formatted file that can be imported into other software for shopping, delivery, and cost analysis.

## Basic Requirements

- [ ] Configuration of different weekend movements should be preloaded into the database. Ex NGVN, TDNG, GMVN, etc.
    - [ ] Users should not be able to modify configurations
- [ ] Must allow users to create new weekends by selecting the weekend movement to associate it with.
    - [ ] Must always work against the associated weekend configuration and no other.
- [ ] Must allow user to add new recipes
    - [ ] Through scraping off of websites
    - [ ] Importing through file
    - [ ] Manual insertion
- [ ] Recipes must be priced based on the weekend movement configuration head count.
    - [ ] Recipes must be labeled based on cost: (Unknown), $ (Inexpensive), $$ (Moderate), $$$ (Expensive), $$$$ (Very Expensive)
- [ ] Must allow users to add all needed recipes for individual meals. Have designated slots for Mains, Sides, and Desserts.
    - [ ] Must allow users to make the first meal of the weekend a potluck.
- [ ] Must allow users to define Theme details
    - [ ] Must allow user to import items to purchase from website links
- [ ] Must provide a progress bar to show how the selected recipes are adding up to the weekend budget
- [ ] Must allow users to generate a formatted file of the weekend plan data.

## Weekend Configuration

Each weekend movement should have a base configuration. This configuration should consiste of:

```json
{
    "name": "<movement name>",
    "abbr": "<movement abbreviation>",
    "days": [
        {
            "day": 1, // The day order for the weekend. Weekends should start at 1 and go in sequential order with no missed numbers.
            "meals": [ ] // accepted values "Breakfast" | "Lunch" | "Dinner"
        }
    ],
    "budget": 0.00 // The weekend budget. Should be in money format, ####.##
}
```

## Meals

There are three available meals per day: Breakfast, Lunch, and Dinner. The weekend movement configuration should define when the weekend starts and what meals are available on each day.

The weekend movement configuration should also be able to define what meals can be considered as potluck eligible.

## Recipes

Recipes should be stored in a json file that can be synced with updates from a public source and stored in an internal database. These recipes will have the following details:

```json
{
    "title": "",
    "description": "",
    "cost_per_serving": 0.00, // Should be in money format, ####.##
    "type": "", // accepted values "Entree" | "Side" | "Dessert" | "Other"
    "labels": [ ], // accepted values "Breakfast" | "Lunch" | "Dinner" | "Soup" | "Salad" | "Sauce". Can be a custom label
    "ingredients": [
        {
            "name": "",
            "measurement": "", // The type of measurement. Ex. Cups, Lbs, grams, oz. bunches, etc.
            "amount": "", // The amount for a single serving
            "section": "" // This is for if the recipe has multiple pieces to it. Example a Cake and Frosting. This should define which section of the recipe this ingredient belongs to. By default should be empty or "General"
        }
    ],
    "directions": [
        {
            "order": 1, // The step order for this direction. This are unique with the section. So, if we have cake and frosting sections, you can have Cake:1 and Cake:2 along with Frosting:1 and Frosting 2.
            "text": "", // The main direction text
            "section": "" // This is for if the recipe has multiple pieces to it. Example a Cake and Frosting. This should define which section of the recipe this ingredient belongs to. By default should be empty or "General"
        }
    ],
    "notes": "" // Additional notes for the recipe. This is just a formatted paragraph with tips around cooking the recipe.

}
```

## Themes

Each meal will have a theme associated with it. A theme should contain the following items, though not all are required:

```json
{
    "title": "",
    "cover_image": "", // path to loaded image {optional}
    "description": "", // Formatted text blob
    "design details": {
        "text": "", // Formatted text blob of overall details
        "needed_items": [
            {
                "name": "", // Name of item to purchase
                "link": "",
                "amount": 0
            }
        ]
    },
    "skits": [ // {optional}
        {
            "name": "",
            "details": "" // Formatted text blob of the skit
        }
    ]
}
```

### Description

This is the overview of the theme and general idea. This can include reference images to help give a visual idea of the theme.

### Design Details

These are the details of everything needed to bring the theme together. This includes table settings and decorations.

* A user should be able to search Amazon or other websites and add links to the design details. This will help organize what needs to be purchased and from where.
* A user should be able to supply images for examples of the theme.

### Skits

These are any dramatized performances that the team does during the meal. There could be multiple skits, so this provides a way to organize the different skits / ideas. Each skit should allow details about what is going to happen or even the ability to write out a script.

## UI

### Main View

#### Initial Startup

When the application is started up for the first time, the user should be able to select from the following buttons:

1. New Weekend Plan
2. Load Weekend Plan
3. Import Weekend Plan

On subsequential loads, the application to load into the last active weekend plan.

##### New Weekend Plan

Provides a new form where the user can:

1. Provide a Unique Name for the Weekend Plan
2. Select a Weekend Configuration to use for the Weekend Plan

Once submitted it should be created in the internal database and load it as the currently active Weekend Plan.

##### Load Weekend Plan

This provides a list of all the weekend plans in the internal database. The user can then select one, in which it should be loaded as the currently active weekend plan the user is working on.

##### Import Weekend Plan

This allows the user to import a weekend plan from a file. If one exists locally, it should ask if the user wants to overwrite the existing one or should merge the two.

If overwritten, just delete the existing weekend plan and import it back using the provided file data.

If merge, the system should merge anything that doesn't have conflicts and ask the user to resolve conflicts by accepting differences or overwriting.

In both cases, the imported plan should be loaded as the active weekend plan.

##### New Weekend Configuration

This allows the user to import a new Weekend Configuration. This works similar to initial startup except, if the weekend already exists, it overwrites it.

#### Post Startup

If the user has already done the initial startup, we should load the last weekend plan that was worked on. Always give the user the ability to go back and start a new weekend plan, load a different weekend plan, import plan updates, or create a new weekend configuration. This should load into the plan overview.

#### Plan Overview

The plan overview is a high level view of the weekend. It should show cards with a description of each meal. Example would be:

```
Saturday Breakfast: <Theme Title>

<Main (Entree or Soup)> w/ <Side Dishes / Salads> and <Dessert> for dessert
```

Everything should be ordered by date

### Meal View

The user interface should be simple and sleek. For meal planning, you should be able to look up a recipe and drag and drop it to the meal currently being viewed. Things can be re-ordered if you want. The recipe should show up as a title and not all the different ingredients. Allow the user to navigate into the recipe to view the full details of the recipe.

There should be a tab or separate section to add in the additional Theme details described above in the Theme section of this document.

The initial state should be a View state. There should be an option to enter Edit mode, in which the above actions can take place.

When in the View state, the user should be able to click recipes and view the recipe.

### Add Recipe

The user should be able to import recipes from a website. After importing the recipe, it should be converted into a single serving.

The user should have the option to manually add new recipes

### Budget Progress

The application should have a progress bar on display whenever a weekend plan is actively loaded. This progress bar should be how all of the prices for the recipes selected for all the meals compares to the weekend configuration budget. Recipe cost should be calculated through {weekend configuration head count} * {recipe price per serving}.

The user should not know the exact cost of the weekend. The budget and recipe costs are hidden from the user, so the progress bar should be an abstract representation of how their recipe selections are stacking up against the overall budget.

### Export Weekend Plan

The user should be able to export the weekend plan and email it to a specified email in the weekend configuration. This process should be done in the background when the export feature is called. The user should not get a file as the result, but just a success or failure alert.