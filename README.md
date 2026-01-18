# NightMoves

A collaborative marketplace connecting software developers with enterprises, enabling monetization of code contributions through commercial licensing.

## Overview

NightMoves is a dual-sided platform that:

- **For Developers:** Publish software components and earn 85% of commercial license fees
- **For Enterprises:** Access curated, commercially-licensed software with legal clarity
- **For Admins:** Manage users, components, subscriptions, and platform operations

## Project Structure

```
NightMoves/
├── docs/
│   ├── IMPLEMENTATION_PLAN.md      # Technical implementation roadmap
│   ├── business/                   # Business model & governance docs
│   └── financial/                  # Financial projections & analysis
└── [Rails app - coming soon]
```

## Documentation

- [Implementation Plan](docs/IMPLEMENTATION_PLAN.md) - Rails application architecture and development phases
- [Business Model](docs/business/nightmoves_business_model.md) - Platform economics and operations
- [Governance Charter](docs/business/nightmoves_governance_charter.md) - Foundation structure
- [Licensing Framework](docs/business/nightmoves_licensing_framework.md) - Dual-licensing approach

## Tech Stack (Planned)

- Ruby on Rails 7.x
- PostgreSQL
- Sidekiq + Redis
- Stripe Connect
- Hotwire (Turbo + Stimulus)
- TailwindCSS

## Key Features

### Customer Facet

**Developers**
- Component publishing and version management
- Earnings dashboard and automated payouts
- Public developer profiles

**Enterprises**
- Organization and team management
- Subscription plans (Basic/Professional/Enterprise)
- Commercial license management
- Compliance and audit tools

### Administrator Facet

- Platform metrics dashboard
- User and organization management
- Component review and moderation
- Financial reporting
- System configuration

## Getting Started

*Rails application setup instructions will be added once the app is initialized.*

## License

See [Licensing Framework](docs/business/nightmoves_licensing_framework.md) for details on the dual-licensing model.
