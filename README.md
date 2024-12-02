# Overview:

evolve is an inclusive self-care app for mental health, providing a safe space to the LGBTQ community.
Get self care tools for your mental health like meditations, mental health tests, prompted journals &
self-care motivations built by leading therapists & coaches.

# Key Features:

### 1. UI Features:

        - Scrollable Grid Layout:
            The app showcases items in a scrollable grid using SwiftUI's LazyVGridfor seamless performance and dynamic updates.

        - Search Bar with Filtering:
            At the top of the UI, a search bar enables users to filter items dynamically by entering keywords.

        - Filter Chips for Categories:
            Below the search bar, interactive filter chips allow users to select multiple categories simultaneously,
            refining the results further.

        - Loading Spinner:
            A visually appealing SwiftUI Activity Indicator appears when new data is being fetched from the backend.

        - Edge Case Handling:
            The app gracefully handles scenarios such as no matching results, API errors, or empty categories.
            Friendly error messages or fallback states are displayed to enhance user experience.
    
### 2. Backend Integration:

        - Mock API with JSON Server:
            The app integrates with a mock API (JSON Server), serving as a backend to fetch and filter data.

        - Pagination:
            The app fetches data in pages, loading items incrementally for improved performance and a smooth user experience.

        - Keyword Filtering and PROBLEM Support:
            API queries support keyword filtering and handle additional constraints, such as filtering for problematic items
            based on specific rules.

### 3. Bonus Features:

        - Debounce Mechanism for Search:
            To avoid excessive API calls, the search bar incorporates a debounce mechanism using Combine's debounce operator,
            delaying API requests until typing stops for a short interval (1 second).

        - Offline Support:
            Data fetched from the API is cached locally using SwiftData, ensuring offline functionality.
            The app detects connectivity and falls back to the cached data when offline.

# Steps to Run the Application:

### 1. Install Node.js

        - Download and install Node.js using the package manager of your choice from the official website: 
            [https://nodejs.org/en/download/package-manager]
    
### 2. Start the Server

        - Open your terminal and navigate to the /server repository directory.

        - Run the following command in the terminal to start the server:
            npm start

### 3. Launch the Application

        - Once the server is running, open the evolve.xcodeproj file in Xcode.
        - Build and run the app in Xcode to launch it.
