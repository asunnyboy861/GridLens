# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | GridLens |
| **Git URL** | git@github.com:asunnyboy861/GridLens.git |
| **Repo URL** | https://github.com/asunnyboy861/GridLens |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Item | Value |
|------|-------|
| **Source Path** | /docs |
| **Pages URL** | https://asunnyboy861.github.io/GridLens/ |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/GridLens/ | ✅ Active |
| Support | https://asunnyboy861.github.io/GridLens/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/GridLens/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/GridLens/terms.html | ✅ Active |

## Repository Structure

### Main App Repository
```
GridLens/
├── GridLens/                       # iOS App Source Code
│   └── GridLens/
│       ├── GridLens.xcodeproj/     # Xcode Project
│       ├── GridLens/               # Swift Source Files
│       │   ├── Views/
│       │   │   ├── AR/             # AR Camera Views
│       │   │   ├── Grid/           # Grid Control Views
│       │   │   ├── Settings/       # Settings Views
│       │   │   └── Paywall/        # Subscription Views
│       │   ├── Models/             # Data Models
│       │   ├── ViewModels/         # Business Logic
│       │   ├── Services/           # AR, Screenshot, Location
│       │   └── Utilities/          # Constants, Extensions
│       └── Assets.xcassets/        # App Icons & Assets
├── docs/                           # Policy Pages (GitHub Pages)
│   ├── index.html                  # Landing Page
│   ├── support.html                # Support Page
│   ├── privacy.html                # Privacy Policy
│   └── terms.html                  # Terms of Use
├── screenshots/                    # App Store Screenshots
├── us.md                           # English Development Guide
├── keytext.md                      # App Store Metadata
├── capabilities.md                 # Capabilities Configuration
├── icon.md                         # App Icon Details
├── price.md                        # Pricing Configuration
└── nowgit.md                       # This File
```
