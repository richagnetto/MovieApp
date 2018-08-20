# MovieApp

This is a movie search app that utilizes the Movie DB (https://www.themoviedb.org/) API to display information about movies based on the users' search.

Design/Workflow:
1. The user is presented with the initial search screen.
2. When the user taps the search bar, a table view with the last 10 successful searches that the user has made appears below the search bar. If this is the first time the user is using the app, there is no suggestion table view.
3. The user can enter a search string and tap the "Search" button on the keyboard to perform a new search.
4. Tapping "Search" takes the user to a new screen with a list of search results with movie name, release year, poster and overview.
5. Tapping any of the suggestions in the suggestion list also takes the user to the same search results screen.
6. The user can navigate back to the search page using the back button.
7. Entering an empty string, a string filled with spaces or a string that returns no data from the API has been handled by displaying an alert to the user asking them to enter a valid search string.

Assumptions:
1. In the movie cell list view, I have made an assumption that each row of the table view should have variable height based on the length of the movie description as it was my understanding that the app should display the entire movie description in the search results list.  

External Libraries:
1. Realm for persistence.
