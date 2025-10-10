# Focus Field Documentation

Welcome to the Focus Field documentation hub. This directory contains comprehensive documentation for users, developers, and contributors.

## 📋 Recent Changes
**January 2025**: Documentation has been reorganized for better structure. All documentation files (except the main README.md) are now located in the `/docs/` folder. If you have bookmarked links to `CHANGELOG.md` or `MONETIZATION_SETUP.md`, please update them to `docs/CHANGELOG.md` and `docs/MONETIZATION_SETUP.md` respectively.

### 📌 Current Project State (October 2025)
- CI pipeline stable: uses `dart format`, localization parity check, coverage (≥70%).
- Localization script refactored (no broken pipes; only fails on true key or artifact drift).
- Monetization scaffolding implemented (subscription tiers, paywall UI, gating). Free trial & analytics integration pending.
- Recent cleanup: removed committed coverage artifact; added `.gitignore` entries for coverage & Flutter ephemeral dirs.
- Large formatting pass applied across codebase (Dart formatter).
- Android emulator launch issues under investigation (Pixel Tablet AVD failing to start locally).
- Final product direction: Ambient Quests (quiet-first profiles, Ambient Score, Quest capsule, compassionate streaks). Mission/Habit docs have been archived.
- Implemented: Adaptive threshold suggestion provider (±2 dB after 3 wins/losses), debug-only long-press to cycle overrides, inline apply hint with auto-clear, and a 24-hour cooldown for suggestions. Unit tests cover wins/losses/neutral, override precedence, and cooldown behavior.
- Implemented: Minimal AmbientSessionEngine and Quest state providers; Quest capsule scaffold and ring subtitle wiring in progress.
- Next focus: move Quest application into the session engine (remove UI-side apply), expose a live calm-percent stream for ring subtitle, and add hysteresis/cooldown tuning behind flags.

See also: the up-to-date Feature Inventory and status tracker in [development/feature-inventory.md](development/feature-inventory.md).

> This section should be updated whenever a major milestone or blocking issue changes.

## 📚 Documentation Structure

### Project Documentation
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[MONETIZATION_SETUP.md](MONETIZATION_SETUP.md)** - Subscription system setup guide
- **[Ambient Quests – Dev Spec](development/AmbientQuests_Dev_Spec.md)** - Final implementation plan and acceptance criteria
- **[Ambient Quests – Copy & Micro-Interactions](development/AmbientQuests_Copy_and_MicroInteractions.md)** - Copy deck and micro-interactions
- Archived: Habit tracking & migration documents moved to `docs/archive/`
- **[Environment Setup](development/environment-setup.md)** - API keys and secrets management *(coming soon)*

### For Users
- **[User Guide](user/user-guide.md)** - Complete guide for end users
- **[FAQ](user/faq.md)** - Frequently asked questions *(coming soon)*
- **[Tutorial Videos](user/tutorials.md)** - Step-by-step video guides *(coming soon)*

### For Developers
- **[Setup Guide](development/setup-guide.md)** - Development environment setup
- **[Feature Inventory (Status)](development/feature-inventory.md)** - What’s done vs. what’s next across major features
- **[API Reference](api/api-reference.md)** - Complete API documentation
- **[Architecture Overview](architecture/system-overview.md)** - System architecture and design
- **[Contributing Guide](development/contributing.md)** - How to contribute *(coming soon)*

### For Deployment
- **[Deployment Guide](deployment/deployment-guide.md)** - Production deployment instructions
- **[iOS Setup](deployment/iOS_SETUP.md)** - iOS platform-specific setup
- **[Android Setup](deployment/ANDROID_SETUP.md)** - Android platform-specific setup
- **[CI/CD Setup](deployment/cicd.md)** - Continuous integration setup *(coming soon)*
- **[Store Guidelines](deployment/store-requirements.md)** - App store submission requirements *(coming soon)*

### For Business Strategy
- **[Business Overview](business/README.md)** - Business strategy and planning hub
- **[Phase 1 Launch Plan](business/phase1-launch-plan.md)** - Immediate launch strategy and execution checklist
- **[Expansion Plan](business/expansion-plan.md)** - Growth strategy and market expansion
- **[Future Roadmap](business/roadmap.md)** - Product and technical development timeline
- **[Revenue Strategy](business/revenue-strategy.md)** - Monetization and financial projections

## 🎯 Quick Start

### For End Users
1. Start with the **[User Guide](user/user-guide.md)**
2. Learn about features and functionality
3. Get tips for optimal usage

### For Developers
1. Follow the **[Setup Guide](development/setup-guide.md)**
2. Review the **[Architecture Overview](architecture/system-overview.md)**
3. Reference the **[API Documentation](api/api-reference.md)**

### For DevOps/Release
1. Read the **[Deployment Guide](deployment/deployment-guide.md)**
2. Set up automated deployment pipelines
3. Follow store submission procedures

## 📋 Documentation Standards

All documentation in this project follows our **[Documentation Standards](DOCUMENTATION_STANDARDS.md)**. Key principles:

- **Clear and Concise**: Easy to understand language
- **Comprehensive**: Complete coverage of topics
- **Up-to-Date**: Regular updates with code changes
- **Accessible**: Proper formatting and navigation
- **Searchable**: Good use of headings and keywords

## 🔄 Maintenance

### Regular Updates
- Documentation is updated with each release
- New features require corresponding documentation
- User feedback drives documentation improvements

### Version Control
- Documentation follows semantic versioning
- Changes are tracked in version control
- Legacy versions maintained for reference

## 🤝 Contributing to Documentation

We welcome documentation contributions! Please see our **[Contributing Guide](development/contributing.md)** *(coming soon)* for:

- Documentation style guidelines
- Review process
- Submission procedures
- Quality standards

### Quick Contribution Tips
1. **Use clear, simple language**
2. **Include code examples where helpful**
3. **Add screenshots for UI instructions**
4. **Test all procedures before documenting**
5. **Follow the established structure**

## 📞 Support

### Documentation Issues
- **Bug Reports**: File issues for documentation errors
- **Improvements**: Suggest enhancements
- **Questions**: Ask for clarification

### Getting Help
- **Email**: support@sparkvibe.com
- **GitHub Issues**: Technical documentation questions
- **Community**: Join our developer discussions

## 🎨 Assets and Media

The **[assets/](assets/)** directory contains:
- Screenshots and images used in documentation
- Diagrams and flowcharts
- Video thumbnails and promotional materials
- Icon sets and branding materials

## 📖 External Resources

### Flutter Documentation
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Flutter Community](https://flutter.dev/community)

### Development Tools
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Android Studio](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/)

### Audio Development
- [Flutter Audio Plugins](https://pub.dev/packages?q=audio)
- [Platform Audio APIs](https://developer.android.com/guide/topics/media/audio-capture)
- [iOS Audio Programming](https://developer.apple.com/documentation/avfoundation/audio_playback_recording_and_processing)

---

## Last Updated
October 7, 2025

**Documentation Version**: 1.0.0  
**Project Version**: 1.0.0

---

*This documentation is maintained by the Focus Field development team. For questions or suggestions, please contact us or open an issue.*
