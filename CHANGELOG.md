# Changelog

All notable changes to the Broadcast Notification System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Rich text formatting in messages
- Scheduled notifications
- Message templates library
- Notification history viewer
- Read receipts and analytics
- Attachment support
- Multi-language support
- Mobile app optimization

## [1.0.0] - 2025-12-10

### Added
- Initial release of Broadcast Notification System
- Canvas App with broadcast notification UI
- Power Automate flow for sending notifications
- Three notification modes:
  - Notify all active users
  - Notify users in a specific queue
  - Notify specific selected users
- Text input with 500 character limit
- Real-time character counter
- Input validation and error handling
- Customer Service Workspace integration
- Security role configuration
- Automated deployment scripts
- Complete documentation suite:
  - Installation guides (quick and detailed)
  - Security configuration guide
  - Sitemap integration guide
  - Troubleshooting guide
  - Export/import scripts
- PowerShell deployment automation
- Solution export/import capabilities

### Security
- App Notification entity privileges configured
- System User read access required
- Queue read access for queue selection
- User-level security for recipients

### Documentation
- Complete installation guide
- Quick start guide
- Security configuration guide
- Architecture documentation
- UI design specifications
- PowerFx formulas reference
- Troubleshooting guide
- Release creation guide

## Version History Format

### [X.Y.Z] - YYYY-MM-DD

#### Added
- New features

#### Changed
- Changes to existing functionality

#### Deprecated
- Features that will be removed in future versions

#### Removed
- Removed features

#### Fixed
- Bug fixes

#### Security
- Security-related changes

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the first production-ready release of the Broadcast Notification System for Dynamics 365 Customer Service.

**Key Highlights**:
- Simple, intuitive interface for supervisors
- Multiple targeting options for notifications
- Native D365 in-app notifications
- Easy deployment with automated scripts
- Comprehensive documentation

**Known Limitations**:
- Text-only messages (no rich formatting)
- No notification scheduling
- No message templates
- No read receipts

**Next Planned Features** (v1.1.0):
- Message templates for common notifications
- Notification history view for supervisors
- Enhanced error handling

---

## How to Use This Changelog

When releasing a new version:

1. Move items from "Unreleased" to a new version section
2. Update the version number and date
3. Document all changes under appropriate categories
4. Link to GitHub issues/PRs where applicable
5. Update README with new version number

---

## Semantic Versioning Guide

- **MAJOR** (X.0.0): Breaking changes, incompatible API changes
- **MINOR** (1.X.0): New features, backward compatible
- **PATCH** (1.0.X): Bug fixes, backward compatible

---

**Current Version**: 1.0.0  
**Last Updated**: December 10, 2025
