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

**Note**: Terms of Use required for IAP subscription apps.

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

## Monetization Model

| Item | Value |
|------|-------|
| **Model** | Subscription (IAP) |
| **Monthly** | $4.99/month |
| **Yearly** | $29.99/year |
| **Lifetime** | $59.99 one-time |

## App Store Connect

| Item | Value |
|------|-------|
| **App Name** | GridLens - AR Grid Overlay Camera |
| **Bundle ID** | com.zzoutuo.GridLens |
| **Primary Category** | Utilities |
| **Secondary Category** | Productivity |
| **Age Rating** | 4+ |

## Key URLs

| Purpose | URL |
|---------|-----|
| GitHub Repo | https://github.com/asunnyboy861/GridLens |
| GitHub Pages | https://asunnyboy861.github.io/GridLens/ |
| Support Email | support@zzoutuo.com |

## Deployment Status

| Phase | Status |
|-------|--------|
| Phase 1: us.md | ✅ Complete |
| Phase 2: Xcode Configuration | ✅ Complete |
| Phase 3: price.md | ✅ Complete |
| Phase 4: Code Generation | ✅ Complete |
| Phase 5: Contact Support | ✅ Complete |
| Phase 6: Build & GitHub Push | ✅ Complete |
| Phase 7: Policy Pages | ✅ Complete |
| Phase 8: keytext.md | ✅ Complete |
| Phase 8.5: Keytext Validation | ✅ Complete |
| Phase 9: Screenshots | ✅ Complete |

## Next Steps

1. Create App in App Store Connect
2. Upload screenshots to App Store Connect
3. Enter metadata from keytext.md
4. Archive and upload IPA via Xcode
5. Submit for App Store Review
