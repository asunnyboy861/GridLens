# GridLens - iOS Development Guide

## Executive Summary

GridLens is an AR-powered ground grid overlay camera app that fills a clear market gap: no existing App Store application provides real-time, adjustable grid visualization overlaid on the ground through an AR camera. Born from a real Reddit user request in r/Archaeology, GridLens enables archaeologists, architects, construction workers, landscape designers, and DIY enthusiasts to see customizable grid patterns (0.25m to 10m) directly on the ground through their iPhone camera.

**Target Audience**: Archaeologists, architects, construction professionals, landscape designers, and DIY enthusiasts in the US market.

**Key Differentiators**:
- Only app offering real-time AR ground grid overlay with adjustable spacing
- Multiple grid sizes (0.25m, 0.5m, 1m, 2m, 5m, 10m) and units (meters, feet, cm, inches)
- Grid labels with coordinate annotations for professional documentation
- Screenshot capture with GPS metadata for field reporting
- Apple-native ARKit + RealityKit for highest tracking accuracy

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Apple Measure | Free, built-in, reliable | No grid overlay, point-to-point only | Full grid visualization with adjustable spacing |
| CamToPlan | Floor plan generation, accurate | No grid overlay, complex UI | Simple grid overlay focused, intuitive controls |
| AR Ruler | Comprehensive measurement tools | Expensive subscription, no grid, complex | Affordable, grid-focused, easy to use |
| AR Fast Area Measurement | Has transparent grid overlay | Grid not adjustable, only for area measurement | Fully adjustable grid with labels and colors |
| Theodolite | Navigation/coordinate overlay | No ground grid, navigation-focused | Purpose-built ground grid overlay |
| EasyMeasure | 3D camera overlay grid | Grid is camera overlay not ground overlay | Ground-anchored grid with plane detection |

## Apple Design Guidelines Compliance

- **AR Best Practices**: Use entire display for AR content; minimize on-screen controls; use semi-transparent indirect controls in screen space
- **Plane Detection**: Provide clear visual feedback when surfaces are detected; guide users to scan environment
- **User Comfort**: Avoid prolonged device holding; provide break reminders for extended sessions
- **Accessibility**: VoiceOver labels for all controls; Dynamic Type support; high contrast grid colors
- **Privacy**: Camera access with clear purpose explanation; Location access only when saving GPS-tagged screenshots
- **ARKit Device Support**: Gracefully handle unsupported devices; display informative messages

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), ARKit + RealityKit (AR engine)
- **Data**: SwiftData for local persistence (grid presets, saved screenshots)
- **Architecture**: MVVM + @Observable
- **Minimum iOS**: 17.0
- **Recommended Device**: iPhone 12 Pro+ (LiDAR for faster plane detection)

## Module Structure

GridLens/
  GridLensApp.swift
  Views/
    AR/
      ARCameraView.swift
      ARCameraOverlay.swift
    Grid/
      GridControlsView.swift
      GridPresetPicker.swift
    Settings/
      SettingsView.swift
      ContactSupportView.swift
    Paywall/
      PaywallView.swift
  ViewModels/
    ARSessionViewModel.swift
    GridViewModel.swift
    PurchaseManager.swift
  Models/
    GridConfiguration.swift
    GridPreset.swift
  Services/
    ARGridRenderer.swift
    ScreenshotManager.swift
    LocationManager.swift
  Utilities/
    Constants.swift
    Extensions.swift

## Implementation Flow

1. Create SwiftData models (GridConfiguration, GridPreset)
2. Build ARSessionViewModel with ARKit plane detection
3. Implement ARGridRenderer for ground grid mesh generation
4. Create ARCameraView with RealityKit ARView integration
5. Build GridControlsView for grid size, color, opacity, unit controls
6. Add grid labels with coordinate annotations
7. Implement ScreenshotManager for capture with GPS metadata
8. Create GridPreset system with SwiftData persistence
9. Build SettingsView with policy links and contact support
10. Implement PurchaseManager with StoreKit 2
11. Create PaywallView following Apple IAP guidelines
12. Add onboarding flow for first-time users

## UI/UX Design Specifications

- **Color Scheme**: Dark theme primary; accent colors: Blue (#007AFF), Green (#34C759), Red (#FF3B30), Yellow (#FFCC00), White (#FFFFFF) for grid lines
- **Typography**: SF Pro system font; grid labels use monospaced for precision
- **Layout**: Full-screen AR camera view; floating semi-transparent control panels at bottom; minimal screen-space controls per Apple AR HIG
- **Controls**: Bottom toolbar with grid size selector, color picker, opacity slider, capture button
- **Animations**: Smooth grid transitions on size change; subtle plane detection pulse; screenshot flash animation
- **iPad**: Side-by-side layout with AR view and controls panel; max content width 720pt for controls
- **Dark Mode**: Full support; grid colors adapt for visibility in both light and dark environments

## Code Generation Rules

- Architecture: MVVM with @Observable macro
- AR lifecycle: Start/stop ARSession in View onAppear/onDisappear
- Memory: Weak references for delegates; remove invisible anchors
- Error handling: ARSession errors shown via alert, never crash
- Accessibility: VoiceOver labels, Dynamic Type
- Performance: Grid line cap at 500 lines; auto-cull distant grid
- Localization: English primary; String Catalog for all strings
- No comments in code unless explicitly requested

## Build and Deployment Checklist

- Verify Bundle ID: com.zzoutuo.GridLens
- Verify Deployment Target: iOS 17.0
- Camera usage description in Info.plist
- Location usage description in Info.plist
- Photo Library usage description in Info.plist
- App Icon configured (1024x1024)
- Build succeeds on iPhone simulator
- Build succeeds on iPad simulator
- AR session starts and detects planes
- Grid overlay renders on detected planes
- Grid size adjustment works
- Screenshot capture saves to Photos
- Push to GitHub repository
