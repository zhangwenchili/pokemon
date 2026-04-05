### Functional requirements
Constraints
- The application has a user model with proper authentication & authorization
- The application uses sessions to identify logged in users
- Use user friendly layout and UI text

Pages: four tabs, a user avatar, and a logout button at the top after logging in
- Login and register page
- User profile page
    - Clicking the user avatar links to the user profile page
    - Displays user avatar and user name
    - User can upload an image to change avatar
- Wild pokemons page: displays a list of Pokémon that the user can catch
    - Each card shows instance nickname, image of species, type of species
    - Type of species shown as text, multi-type separeted by comma
    - Each card links to instance detail page
    - Paginated with a page limit of 50
- Team page: displays up to 6 Pokémon instances assigned to the user's team
    - Display same as wild pokemons page
- Repo page: displays all Pokémon instances owned by the current user but not assigned to the team
    - Display same as wild pokemons page
- Instance detail page
    - Shows instance nickname, image of species, name of species, type of species, current hit points
    - If it's wild pokemon, show "catch" button, pokemon caught will go to repo first
    - If it's in team, show "move to repo" button
    - If it's in repo, show "move to team" button (grey out if team has already six instances)
    - If it's in team or repo, show "release" button to delete that instance
    - After clicking the action buttons, page updates
- Pokedex page: a list of pokemon species
    - Each species displayed as card
    - Each card shows name of species, image of species, type of species
    - Type of species shown as text, multi-type separeted by comma
    - Each card links to species detail page
- Species detail page
    - Just shows name of species, image of species, name of species, type of species


### Technical requirements
- The application is functional (no errors) and logically sound
- Use bootstrap
- CSS should be in a stylesheet and do not use inline styling
