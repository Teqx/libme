Libme, an OpenLibrary client to store the books you have on your bookshelf.

Rubric:
* No 3rd party frameworks
* Has a static SwiftUI launch screen
* Features are completed
* App has two screens with Lists
    * Each tab has a list
* In the Bookshelf list, the list row has a title, subtitle, and image
    * Both lists navigate to a detail view (search tab should probably show a sheet instead)
    * Viewing the detail view of the search item allows the user to add it to their bookshelf
    * Can easily search for terms that have hundreds of items (try "Lord of the Rings")
* The app makes two network calls: one for the search query and one for downloading the cover images
    * No API key needed with OpenLibrary
    * No extreme request limit
* The app hopefully handles all typical errors with a message on the search screen
* The app uses SwiftData to save the books to the bookshelf. User defaults are used for persistent mechanics (first run view, color scheme switcher, tab preference)
* MainActor is used for methods that need it. async/await is used for networking
* User should see text if the views are empty
* Screens seem to work on different iPhone sizes
* Code organization
     * Since I used SwiftData, I used iOS 17's @Observable instead of ObservableObject. The same, except you no longer need @Published. @State instead of @StateObject for the instance. @Bindable (or nothing) instead of @ObservedObject.
     * SwiftLint passes
* No tests as of now :(
* App includes a custom app icon, onboarding screen (with animation), custom display name, and styled text.
