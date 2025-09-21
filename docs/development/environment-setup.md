# Environment Setup & Secrets Management

## Overview
This guide explains how to properly configure API keys and environment variables for Focus Field development and production builds. The system is designed to keep sensitive information out of version control while providing a smooth developer experience.

## Prerequisites
- Flutter development environment setup
- Access to RevenueCat dashboard
- Understanding of environment variables

## Environment Configuration Methods

### Method 1: Environment File (Recommended for Development)

#### 1. Create Local Environment File
```bash
# Copy the example file
cp .env.example .env

# Edit with your actual keys
vim .env
```

#### 2. Configure Your API Keys
```bash
# .env file content
IS_DEVELOPMENT=true
ENABLE_MOCK_SUBSCRIPTIONS=true
REVENUECAT_API_KEY=rcat_xxxxxxxxxxxxx
FIREBASE_API_KEY=AIzaxxxxxxxxxxxxxxx
SENTRY_DSN=https://xxxxx@sentry.io/xxxxx
```

#### 3. Run Development Build
```bash
# Automatically loads .env file
./scripts/build-dev.sh

# Or run directly
flutter run
```

### Method 2: Dart Define Flags (Production)

#### Direct Command Line
```bash
flutter run --dart-define=REVENUECAT_API_KEY=your_key \
           --dart-define=IS_DEVELOPMENT=false \
           --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
```

#### Production Build Script
```bash
# Set environment variables
export REVENUECAT_API_KEY="your_actual_key"
export IS_DEVELOPMENT="false"

# Build for production
./scripts/build-prod.sh
```

### Method 3: System Environment Variables
```bash
# Set in your shell profile (.bashrc, .zshrc, etc.)
export REVENUECAT_API_KEY="your_key"
export FIREBASE_API_KEY="your_key"

# Then build normally
flutter build apk --release
```

## API Key Configuration

### RevenueCat Setup

1. **Create RevenueCat Account**
   - Go to [RevenueCat Dashboard](https://app.revenuecat.com)
   - Create new project for Focus Field

2. **Get API Key**
   - Navigate to Project Settings → API Keys
   - Copy the Public SDK Key (starts with `rcat_`)

3. **Configure Products**
   ```
   Premium Monthly: premium_monthly_199
   Premium Yearly: premium_yearly_999
   Premium Plus Monthly: premium_plus_monthly_399
   Premium Plus Yearly: premium_plus_yearly_2499
   ```

### Firebase Setup (Optional)

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create project for Focus Field

2. **Get Configuration**
   - Add iOS/Android apps
   - Download configuration files
   - Copy API key from configuration

## Security Best Practices

### ✅ DO
- Use environment variables for all sensitive data
- Add all secret files to `.gitignore`
- Use different keys for development and production
- Validate API keys before using them
- Use build scripts for consistent configuration
- Rotate API keys regularly

### ❌ DON'T
- Commit API keys to version control
- Share API keys in plain text
- Use production keys in development
- Hardcode secrets in source code
- Leave default/example keys in production builds

## Troubleshooting

### Common Issues

#### 1. "RevenueCat API key not configured"
```bash
# Check if key is set
echo $REVENUECAT_API_KEY

# Set the key
export REVENUECAT_API_KEY="rcat_your_key_here"

# Or add to .env file
echo "REVENUECAT_API_KEY=rcat_your_key_here" >> .env
```

#### 2. "Mock subscriptions in production"
```bash
# Ensure production mode is set
export IS_DEVELOPMENT=false
export ENABLE_MOCK_SUBSCRIPTIONS=false

# Or use production build script
./scripts/build-prod.sh
```

#### 3. Environment file not loading
```bash
# Check file exists
ls -la .env

# Check file format (no spaces around =)
cat .env | grep -v '^#'

# Reload environment
source .env
```

### Validation Commands

```bash
# Check current configuration
flutter run --dart-define=REVENUECAT_API_KEY=test | grep "Environment:"

# Test with specific configuration
flutter run --dart-define=IS_DEVELOPMENT=true \
           --dart-define=REVENUECAT_API_KEY=test_key
```

## CI/CD Configuration

### GitHub Actions
```yaml
env:
  REVENUECAT_API_KEY: ${{ secrets.REVENUECAT_API_KEY }}
  FIREBASE_API_KEY: ${{ secrets.FIREBASE_API_KEY }}

steps:
  - name: Build Release
    run: |
      flutter build apk --release \
        --dart-define=REVENUECAT_API_KEY="${REVENUECAT_API_KEY}" \
        --dart-define=IS_DEVELOPMENT=false
```

### Environment Variables in CI
- Store secrets in repository secrets
- Use different keys for different environments
- Never expose secrets in logs

## Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `REVENUECAT_API_KEY` | Yes (Prod) | `REVENUECAT_API_KEY_NOT_SET` | RevenueCat public SDK key |
| `FIREBASE_API_KEY` | No | `FIREBASE_API_KEY_NOT_SET` | Firebase project API key |
| `IS_DEVELOPMENT` | No | `true` | Enable development mode |
| `ENABLE_MOCK_SUBSCRIPTIONS` | No | `true` | Use mock purchases |
| `SENTRY_DSN` | No | `""` | Error tracking endpoint |

## Development Workflow

### 1. Initial Setup
```bash
# Clone repository
git clone https://github.com/yourusername/silence-score.git
cd silence-score

# Install dependencies
flutter pub get

# Configure environment
cp .env.example .env
vim .env  # Add your API keys
```

### 2. Daily Development
```bash
# Quick development build
./scripts/build-dev.sh

# Or run in development mode
flutter run
```

### 3. Production Release
```bash
# Set production environment
export REVENUECAT_API_KEY="prod_key_here"

# Build for production
./scripts/build-prod.sh
```

## Related Documents
- [MONETIZATION_SETUP.md](../MONETIZATION_SETUP.md) - RevenueCat configuration
- [Setup Guide](setup-guide.md) - General development setup
- [Deployment Guide](../deployment/deployment-guide.md) - Production deployment

## Last Updated
January 27, 2025

---

*This document covers secure environment configuration for Focus Field. Keep your API keys safe and never commit them to version control.* 