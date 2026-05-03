# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Camera access required for AR ground grid overlay
- Location access required for GPS-tagged screenshots
- Photo Library access required for saving screenshots
- ARKit requires device support check

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Camera (NSCameraUsageDescription) | Configured | Info.plist |
| Location When In Use (NSLocationWhenInUseUsageDescription) | Configured | Info.plist |
| Photo Library Add (NSPhotoLibraryAddUsageDescription) | Configured | Info.plist |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| ARKit | Auto-detected | No manual config needed - ARKit is a framework, not an entitlement |

## No Configuration Needed
- Push Notifications: Not required
- iCloud/CloudKit: Not required (local storage only)
- HealthKit: Not applicable
- In-App Purchase: Will be configured in Phase 3 if subscription model chosen
- Background Modes: Not required
- Siri: Not required
- Apple Watch: Not applicable

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
