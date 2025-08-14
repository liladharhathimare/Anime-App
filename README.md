🎌 AnimeHub – Flutter Anime App

A beautiful, fast, and lightweight Flutter app to discover trending anime, search titles, view details, and manage your personal watchlist. Built with clean architecture, smooth animations, and offline-friendly caching.

✨ Features

🔥 Trending & Popular lists (paginated)

🔎 Search anime by title

📄 Detailed pages: synopsis, genres, rating, episodes, status

⭐ Watchlist / Favorites (local persistent storage)

🧭 Smart navigation with deep-link–ready routes

⚡ Fast & responsive UI with shimmer placeholders

📶 Offline support via local cache (optional)

🌙 Dark/Light themes

API: Uses the free Jikan REST API (MyAnimeList wrapper). You can swap to AniList GraphQL if preferred.

🏗️ Tech Stack

Flutter 3.x (Dart)

State Management: Provider (ChangeNotifier)

HTTP: dio

Local Storage: sqflite + shared_preferences (watchlist & cache)

Image Caching: cached_network_image

Routing: go_router (or Navigator 2.0)

Animations: implicit & hero animations
