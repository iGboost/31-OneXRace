# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OneXRace is an iOS racing application built with UIKit and Swift. The project uses a clean, programmatic UI approach without storyboards and follows modern iOS architecture patterns with scene delegates.

## Build Commands

```bash
# Build the project
xcodebuild -project OneXRace.xcodeproj -scheme OneXRace -destination 'platform=iOS Simulator,name=iPhone 15' build

# Clean build folder
xcodebuild -project OneXRace.xcodeproj -scheme OneXRace clean

# Build for device (requires proper signing)
xcodebuild -project OneXRace.xcodeproj -scheme OneXRace -destination 'generic/platform=iOS' build
```

## Project Structure

- `OneXRace/App/` - Application lifecycle (AppDelegate, SceneDelegate, Info.plist)
- `OneXRace/Views/` - UI components and view controllers  
- `OneXRace/Resources/` - Assets, images, and other resources
- `OneXRace/Base.lproj/` - Localization files

## Architecture Notes

- **UIKit-based** with programmatic UI (no main storyboard)
- **Scene-based architecture** using SceneDelegate for modern iOS multi-scene support
- **MVC pattern** for clean separation of concerns
- Root view controller set programmatically in `SceneDelegate.swift:22`

## Development Configuration

- **iOS Deployment Target:** 16.6 minimum, 18.4 project setting
- **Swift Version:** 5.0
- **Supported Devices:** iPhone only
- **Bundle ID:** com.vodet.OneXRace
- **Code Signing:** Automatic

## Testing

Currently no test targets are configured. To add testing:
1. Add Unit Test target in Xcode
2. Add UI Test target for interface testing
3. Configure test schemes

## Dependencies

Pure iOS SDK project with no external dependencies. Uses:
- UIKit for user interface
- Foundation for core functionality