# MatchMate

A SwiftUI profile review app backed by the [Random User API](https://randomuser.me/). Profiles can be accepted or declined from the list or detail screen, and the local decision survives relaunches through Core Data.

## Output
<img width="120.6" height="262.2" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-24 at 12 31 18" src="https://github.com/user-attachments/assets/60c0c98a-cc15-43d8-b313-e0705d9544e7" />
<img width="120.6" height="262.2" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-24 at 00 59 02" src="https://github.com/user-attachments/assets/06cdaa6c-11c7-4c44-81a8-a1308c8878b7" />
<img width="120.6" height="262.2" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-24 at 00 58 55" src="https://github.com/user-attachments/assets/e207140e-2c8b-4873-9813-03c2a4416597" />




## Requirements

- macOS with Xcode installed
- An iOS Simulator or a connected iOS device
- Network access for the initial profile fetch

No third-party packages or external services need to be configured.

## Run

1. Open `MatchMate.xcodeproj` in Xcode.
2. Select the `MatchMate` scheme and an iOS Simulator.
3. Build and run with `Cmd+R`.

The app requests ten profiles at a time from Random User using the stable seed `matchmate`. On a later launch, cached profiles are shown immediately and the next page is fetched in the background.

### Command line

From the repository root:

```sh
xcodebuild -project MatchMate.xcodeproj \
  -scheme MatchMate \
  -destination 'platform=iOS Simulator,name=<available simulator>' \
  test
```

Replace `<available simulator>` with a simulator installed on the machine, such as `iPhone 16`.

## Architecture

```text
SwiftUI Views
  ProfileListView / ProfileCardView / ProfileDetailView
              |
              v
      ProfileListViewModel
              |
              v
       ProfileRepository
        /             \
       v               v
DefaultProfileRepository  UITestProfileRepository
       |
       +--> URLSessionAPIClient --> Random User API
       |
       +--> PersistenceController --> Core Data / ProfileEntity
```

- **App composition:** `MatchMateApp` creates an `AppContainer`. Production uses `URLSessionAPIClient`, `DefaultProfileRepository`, and a disk-backed `PersistenceController`.
- **Presentation:** SwiftUI owns rendering and navigation. `ProfileListViewModel` owns loading, pagination triggers, offline state, and status updates. Detail actions call back into the list view model.
- **Data contract:** DTOs model the API response; `Profile` is the app model; the repository maps between DTOs, Core Data entities, and app models.
- **Testing:** unit tests inject mock repositories. UI tests pass a launch argument that selects `UITestProfileRepository` and an in-memory store, making the first profile deterministic.

## Database Choice

The app uses **Core Data** with an `NSPersistentContainer` and a single `ProfileEntity`.

Core Data fits this app because it provides durable local caching, typed generated entity access, and straightforward updates for a small offline-readable dataset without adding a database dependency. The entity stores profile details plus:

- `status`: `pending`, `accepted`, or `declined`
- `page`: the API page that produced the record
- `sortIndex`: a stable global ordering value used when reading cached profiles

The repository upserts by the Random User UUID, so fetching the same seeded page does not create duplicates. Status is only assigned a default when a record has no existing status, which preserves local decisions during refreshes.

## Pagination and Status Sync

### Pagination

- The API is called with `results=10`, a stable `seed=matchmate`, and a one-based page number.
- On launch, cached profiles load first. The highest cached page becomes the repository's current page.
- The list observes each card's appearance. When an item is within the final three loaded profiles, `loadNextPage()` runs.
- The repository fetches `currentPage + 1`, upserts the page into Core Data, advances `currentPage`, and returns the complete sorted local dataset.
- An `isLoadingMore` guard prevents overlapping page requests.
- If a refresh fails while cached data exists, the cached list remains visible and the UI shows an offline indicator.

### Status

- Accept and decline are local actions. The repository writes the new status to Core Data first.
- The view model changes its published list only after persistence succeeds, preventing the UI from claiming a failed update succeeded.
- Because Random User is read-only for this use case, there is currently no server-side status synchronization or conflict resolution.
- Status changes made in the detail view use the same repository and update callback as list actions.

## Tests

The project contains:

- `MatchMateTests`: view model tests for cached loading, accept/decline updates, and load errors.
- `MatchMateUITests`: launch, deterministic data, list actions, detail navigation, and detail actions.

Run all tests from Xcode with `Cmd+U`, or use the command-line command above.

## Known Gaps

- There is no remote endpoint for persisting accept/decline decisions; status is device-local.
- Pagination has no explicit end-of-results condition, so the list keeps requesting pages as the user reaches the end.
- There is no retry control or exponential backoff after a network failure; another load is needed to try again.
- The repository uses the view context directly and does not move larger fetch/save work to a background context.
- API and repository behavior has less direct coverage than the view models and UI flows.
- Image caching is in-memory only, so cached images are lost when the process exits.
- The README and project do not currently define CI, code coverage thresholds, or a release/distribution workflow.

## Rough Effort

The work is roughly **8-12 focused hours**, including the SwiftUI screens, Core Data cache, networking, image caching, dependency injection, accessibility identifiers, unit tests, and UI tests. The commits span roughly 17 hours of elapsed clock time with pauses between changes.
