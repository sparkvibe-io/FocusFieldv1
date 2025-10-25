# Documentation Standards for Focus Field

## Overview
This document establishes documentation standards for the Focus Field project to ensure consistency, clarity, and maintainability across all documentation files.

## Principles

### 0. Product Design Policies (Enforced)
- No scrolling on main pages (Home/Summary/Activity). Prefer compact, tabbed, or carousel layouts over long lists.
- Advertisements remain visible at all times; reserve banner space and prevent overlap with tappable controls.
- Follow Material 3 with minimal, non‑repeatable content; avoid duplicating information across widgets.

### 1. Clarity and Accessibility
- Write for both technical and non-technical audiences
- Use clear, concise language avoiding jargon when possible
- Provide context and examples for complex concepts
- Include visual aids (diagrams, screenshots) when helpful

### 2. Consistency
- Follow standardized formatting and structure
- Use consistent terminology throughout all documents
- Maintain uniform style for headings, code blocks, and links
- Apply consistent file naming conventions

### 3. Maintainability
- Keep documentation close to the code it describes
- Update documentation alongside code changes
- Version control all documentation changes
- Regular review and cleanup of outdated content

## File Structure

### Documentation Organization
```
/docs/
├── DOCUMENTATION_STANDARDS.md (this file)
├── api/                        # API documentation
├── architecture/              # System architecture docs
├── deployment/               # Deployment guides
├── development/              # Development guides
├── user/                     # User guides and tutorials
└── assets/                   # Images, diagrams, screenshots
    ├── images/
    ├── diagrams/
    └── screenshots/
```

### Root Level Files
**IMPORTANT**: Only the primary README.md should exist in the project root directory.

**Allowed in Root:**
- `README.md` - Primary project overview and getting started guide
- `CLAUDE.md` - Business/launch context and operational notes (exception to support product management workflow)

**Required to be in /docs/:**
- `CHANGELOG.md` - Version history and release notes → `/docs/CHANGELOG.md`
- `MONETIZATION_SETUP.md` - Setup guides → `/docs/MONETIZATION_SETUP.md`
- `LICENSE` - Project license (if not LICENSE file without extension)
- Platform-specific setup files → `/docs/deployment/`
- All other documentation files

**Exceptions**:
- Third-party dependency documentation (e.g., `./ios/Pods/*/CHANGELOG.md`)
- Auto-generated documentation files
- Platform tooling configuration files

**Rationale**: 
- Keeps root directory clean and focused
- Prevents documentation sprawl
- Improves project organization and navigation
- Follows industry best practices for documentation architecture

All other documentation must reside in the `/docs/` folder hierarchy.

### File Reference Examples
After moving files to comply with standards:

**Correct References:**
- From root README: `[CHANGELOG](docs/CHANGELOG.md)`
- From docs/business/: `[Setup Guide](../MONETIZATION_SETUP.md)`
- From docs/: `[Business Plan](business/phase1-launch-plan.md)`

**Incorrect References (after reorganization):**
- ❌ `[CHANGELOG](CHANGELOG.md)` (from root - file moved)
- ❌ `[Setup](../../MONETIZATION_SETUP.md)` (from docs/business/ - file moved)

## File Naming Conventions

### General Rules
- Use SCREAMING_SNAKE_CASE for standards and important documents
- Use kebab-case for general documentation files
- Use PascalCase for architecture diagrams and technical specs
- Always use `.md` extension for markdown files

### Examples
- ✅ `DOCUMENTATION_STANDARDS.md`
- ✅ `api-reference.md`
- ✅ `deployment-guide.md`
- ✅ `user-authentication.md`
- ✅ `DatabaseSchema.md`
- ❌ `api_reference.md`
- ❌ `Deployment Guide.md`
- ❌ `userauth.md`

## Document Structure

### Standard Document Template
```markdown
# Document Title

## Overview
Brief description of what this document covers.

## Prerequisites (if applicable)
- List of requirements
- Knowledge assumptions
- Dependencies

## Content Sections
Organized content with clear headings.

### Subsections
Use h3 for major subsections.

#### Details
Use h4 for specific details within subsections.

## Examples (if applicable)
Code examples, screenshots, or practical demonstrations.

## Troubleshooting (if applicable)
Common issues and their solutions.

## Related Documents
Links to related documentation.

## Last Updated
Date of last significant update.
```

## Formatting Standards

### Headings
- H1 (`#`) - Document title (only one per document)
- H2 (`##`) - Major sections
- H3 (`###`) - Subsections
- H4 (`####`) - Detail sections
- H5 (`#####`) - Rare use, for sub-details
- H6 (`######`) - Avoid unless absolutely necessary

### Code Formatting
- Use `inline code` for single items, file names, and short commands
- Use code blocks with language specification:
```dart
// Example Dart code
void main() {
  print('Hello, Focus Field!');
}
```

### Lists
- Use `-` for unordered lists
- Use `1.` for ordered lists
- Indent sub-items with 2 spaces

### Links
- Use descriptive link text: `[deployment guide](deployment/android-setup.md)`
- Avoid generic text like "click here" or "read more"
- Use relative paths for internal documentation links
- Include anchor links for long documents: `[API Reference](#api-reference)`

### Tables
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
```

### Emphasis
- Use **bold** for important terms and concepts
- Use *italics* for emphasis and foreign terms
- Use `code formatting` for technical terms and file paths

## Content Guidelines

### Writing Style
- Write in active voice when possible
- Use present tense for current features
- Use future tense for planned features
- Be concise but complete
- Include examples and context

### Technical Accuracy
- Test all code examples before inclusion
- Verify all commands and procedures
- Update version numbers and dependencies
- Include error handling and edge cases

### Accessibility
- Provide alt text for images
- Use descriptive link text
- Maintain logical heading hierarchy
- Ensure content is screen reader friendly

## Visual Assets

### Screenshots
- Use consistent device/browser settings
- Highlight relevant UI elements
- Keep resolution appropriate (not too large/small)
- Store in `/docs/assets/screenshots/`
- Name files descriptively: `settings-screen-android.png`

### Diagrams
- Use consistent styling and colors
- Export in multiple formats (SVG preferred, PNG fallback)
- Store in `/docs/assets/diagrams/`
- Include source files when possible

### Images
- Optimize file sizes for web
- Use appropriate formats (PNG for screenshots, SVG for diagrams)
- Store in `/docs/assets/images/`

## Review Process

### Documentation Reviews
- All documentation changes require review
- Technical accuracy verification
- Style and formatting consistency check
- Link validation and testing
 - UI conformance checklist: no-scroll on main tabs, ad visible, M3 minimalism

### Update Schedule
- Review documentation quarterly
- Update with major releases
- Immediate updates for breaking changes
- Archive outdated documentation

## Tools and Automation

### Recommended Tools
- **Markdown Editor**: Any editor with markdown preview
- **Diagram Creation**: Draw.io, Mermaid, or similar
- **Screenshot Tools**: Platform-specific tools with annotation
- **Link Checkers**: Automated link validation tools

### Automation
- Automated link checking in CI/CD
- Documentation build validation
- Style guide enforcement tools
- Regular archival of outdated content

## Templates

### API Documentation Template
See: `/docs/templates/api-template.md` (to be created)

### User Guide Template
See: `/docs/templates/user-guide-template.md` (to be created)

### Architecture Document Template
See: `/docs/templates/architecture-template.md` (to be created)

## Compliance

### Standards Adherence
- All contributors must follow these standards
- Documentation PRs require standards compliance
- Regular audits for consistency
- Training materials for new contributors

### Exceptions
- Exceptions require approval from project maintainers
- Document reasons for exceptions
- Temporary exceptions must have expiration dates

---

## Revision History

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-01-27 | 1.1.0 | Added root folder policy enforcement, moved CHANGELOG.md and MONETIZATION_SETUP.md to docs/, added file reference examples | AI Assistant |
| 2025-07-25 | 1.0.0 | Initial documentation standards | AI Assistant |

---

**Note**: This document should be reviewed and updated whenever documentation processes change. All contributors should familiarize themselves with these standards before contributing documentation.
