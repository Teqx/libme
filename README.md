Libme, an OpenLibrary client to store the books you have on your bookshelf.

[Demo video](https://www.loom.com/share/6b93067367034e3fbae0bf1fa20555fb?sid=556a9fbd-754a-441d-8eef-3ea754a241cd)

* App has two screens
    * Each tab has a list
* In the Bookshelf list, the list row has a title, subtitle, and image
    * Both lists navigate to a detail view (search tab should probably show a sheet instead)
    * Viewing the detail view of the search item allows the user to add it to their bookshelf
    * Can easily search for terms that have hundreds of items (try "Lord of the Rings")
* The app makes two network calls: one for the search query and one for downloading the cover images
    * No API key needed with OpenLibrary
    * No extreme request limit
* The app handles typical errors with a message on the search screen
* The app uses SwiftData to save the books to the bookshelf. User defaults are used for persistent mechanics (first run view, color scheme switcher, tab preference)
* Screens work on different iPhone sizes
* Code organization
     * Since I used SwiftData, I used iOS 17's @Observable instead of ObservableObject.
     * SwiftLint passes
* Tests have been added. Unit tests have 25% CC, and the UI test has between 85 and 92% (due to Onboarding view being present)

