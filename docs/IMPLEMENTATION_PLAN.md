# NightMoves Rails Implementation Plan

## Overview

NightMoves is a dual-sided marketplace connecting software developers with enterprises. This document outlines the implementation plan for a Ruby on Rails web application with two primary facets:

1. **Customer Facet** - For developers and enterprises
2. **Administrator Facet** - For platform operations and management

---

## Architecture Overview

### Technology Stack

- **Framework:** Ruby on Rails 8.x
- **Database:** Sqlite
- **Authentication:** Devise with role-based access
- **Authorization:** Pundit
- **Admin Panel:** ActiveAdmin or custom admin namespace
- **Background Jobs:** Sidekiq with Redis
- **Payments:** Stripe Connect (for marketplace payouts)
- **Search:** Elasticsearch for full-text search
- **File Storage:** Active Storage with S3
- **Frontend:** Hotwire (Turbo + Stimulus)

### Application Structure

```
nightmoves/
├── app/
│   ├── controllers/
│   │   ├── admin/           # Administrator controllers
│   │   ├── api/             # API controllers
│   │   ├── developers/      # Developer-specific controllers
│   │   └── enterprises/     # Enterprise-specific controllers
│   ├── models/
│   ├── views/
│   │   ├── admin/
│   │   ├── developers/
│   │   └── enterprises/
│   ├── policies/            # Pundit authorization policies
│   ├── services/            # Business logic services
│   └── jobs/                # Background jobs
├── config/
├── db/
│   └── migrate/
└── spec/                    # RSpec tests
```

---

## Database Schema Design

### Core Models

#### Users
```ruby
# users table
- id: bigint (PK)
- email: string (unique, not null)
- encrypted_password: string
- role: enum (developer, enterprise, admin)
- first_name: string
- last_name: string
- avatar_url: string
- bio: text
- website: string
- github_username: string
- stripe_account_id: string        # For Stripe Connect payouts
- email_verified_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Organizations (for Enterprise accounts)
```ruby
# organizations table
- id: bigint (PK)
- name: string (not null)
- slug: string (unique)
- description: text
- logo_url: string
- website: string
- billing_email: string
- stripe_customer_id: string
- created_at: datetime
- updated_at: datetime
```

#### Organization Memberships
```ruby
# organization_memberships table
- id: bigint (PK)
- organization_id: bigint (FK)
- user_id: bigint (FK)
- role: enum (owner, admin, member)
- created_at: datetime
- updated_at: datetime
```

#### Components (Software Packages)
```ruby
# components table
- id: bigint (PK)
- developer_id: bigint (FK -> users)
- name: string (not null)
- slug: string (unique)
- tagline: string
- description: text
- readme: text
- repository_url: string
- documentation_url: string
- category_id: bigint (FK)
- license_type: enum (apache2, mit, proprietary)
- status: enum (draft, pending_review, published, archived)
- downloads_count: integer (default: 0)
- stars_count: integer (default: 0)
- commercial_price_cents: integer   # Price for commercial license
- featured: boolean (default: false)
- published_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Component Versions
```ruby
# component_versions table
- id: bigint (PK)
- component_id: bigint (FK)
- version: string (not null)
- changelog: text
- release_notes: text
- package_url: string              # S3 URL to package
- checksum: string
- min_ruby_version: string
- min_rails_version: string
- status: enum (draft, published, deprecated)
- downloads_count: integer (default: 0)
- published_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Categories
```ruby
# categories table
- id: bigint (PK)
- name: string (not null)
- slug: string (unique)
- description: text
- icon: string
- parent_id: bigint (FK -> categories, nullable)
- position: integer
- components_count: integer (default: 0)
- created_at: datetime
- updated_at: datetime
```

#### Subscriptions (Enterprise Plans)
```ruby
# subscriptions table
- id: bigint (PK)
- organization_id: bigint (FK)
- plan: enum (basic, professional, enterprise)
- status: enum (active, canceled, past_due, trialing)
- stripe_subscription_id: string
- current_period_start: datetime
- current_period_end: datetime
- canceled_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Commercial Licenses
```ruby
# commercial_licenses table
- id: bigint (PK)
- component_id: bigint (FK)
- organization_id: bigint (FK)
- license_key: string (unique)
- status: enum (active, expired, revoked)
- seats: integer (default: 1)
- price_cents: integer
- expires_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Transactions
```ruby
# transactions table
- id: bigint (PK)
- commercial_license_id: bigint (FK, nullable)
- subscription_id: bigint (FK, nullable)
- organization_id: bigint (FK)
- amount_cents: integer (not null)
- platform_fee_cents: integer      # 15% platform fee
- developer_payout_cents: integer  # 85% to developer
- currency: string (default: 'usd')
- status: enum (pending, completed, failed, refunded)
- stripe_payment_intent_id: string
- stripe_transfer_id: string       # For developer payout
- transaction_type: enum (license_purchase, subscription, renewal)
- created_at: datetime
- updated_at: datetime
```

#### Payouts (Developer Earnings)
```ruby
# payouts table
- id: bigint (PK)
- developer_id: bigint (FK -> users)
- amount_cents: integer (not null)
- status: enum (pending, processing, completed, failed)
- stripe_payout_id: string
- period_start: date
- period_end: date
- paid_at: datetime
- created_at: datetime
- updated_at: datetime
```

#### Reviews
```ruby
# reviews table
- id: bigint (PK)
- component_id: bigint (FK)
- user_id: bigint (FK)
- rating: integer (1-5)
- title: string
- body: text
- helpful_count: integer (default: 0)
- created_at: datetime
- updated_at: datetime
```

#### Downloads
```ruby
# downloads table
- id: bigint (PK)
- component_version_id: bigint (FK)
- user_id: bigint (FK, nullable)
- organization_id: bigint (FK, nullable)
- ip_address: string
- user_agent: string
- created_at: datetime
```

---

## Customer Facet Features

### Developer Features

#### Authentication & Profile
- Sign up / Sign in (email, GitHub OAuth)
- Email verification
- Profile management
- Stripe Connect onboarding for payouts
- Public developer profile page

#### Component Management
- Create new components
- Upload component versions (gem packages)
- Write documentation (Markdown editor)
- Set pricing for commercial licenses
- View download statistics
- Respond to reviews

#### Earnings Dashboard
- View total earnings
- Transaction history
- Pending payouts
- Payout history
- Revenue analytics (by component, over time)

#### Discovery
- Browse marketplace
- Search components
- View component details
- Star/bookmark components

### Enterprise Features

#### Authentication & Organization
- Sign up / Sign in
- Create/manage organization
- Invite team members
- Manage member roles

#### Subscription Management
- View subscription plans
- Subscribe to a plan (Basic/Professional/Enterprise)
- Upgrade/downgrade plan
- View billing history
- Manage payment methods

#### Component Usage
- Browse marketplace
- Search components
- View component details
- Purchase commercial licenses
- Download licensed components
- View license keys
- Track usage across team

#### Compliance Dashboard
- View all active licenses
- License expiration alerts
- Usage reports
- Audit logs

---

## Administrator Facet Features

### Dashboard
- Platform metrics overview
  - Total users (developers, enterprises)
  - Total components
  - Revenue (MRR, ARR)
  - Transaction volume
  - Active subscriptions
- Recent activity feed
- Alerts and notifications

### User Management
- List all users with filters
- View user details
- Edit user profiles
- Suspend/ban users
- Impersonate users (for support)
- Manage admin roles

### Organization Management
- List all organizations
- View organization details
- Edit organization settings
- Manage subscriptions manually
- View member lists

### Component Management
- List all components with filters
- Review pending components
- Approve/reject components
- Edit component details
- Feature/unfeature components
- Remove/archive components
- Manage categories

### Financial Management
- Revenue reports
- Transaction history
- Subscription analytics
- Payout management
- Refund processing
- Tax reporting data

### Content Moderation
- Review flagged content
- Manage reviews
- Handle DMCA requests

### System Settings
- Platform configuration
- Email templates
- Pricing tiers
- Commission rates
- Feature flags

### Audit & Compliance
- System audit logs
- User activity logs
- Security events
- Data export (GDPR)

---

## API Design

### Public API (v1)

```
GET    /api/v1/components              # List components
GET    /api/v1/components/:slug        # Get component details
GET    /api/v1/components/:slug/versions  # List versions
GET    /api/v1/categories              # List categories
GET    /api/v1/developers/:username    # Public developer profile
```

### Authenticated API (v1)

```
# Developer endpoints
GET    /api/v1/me                      # Current user
PATCH  /api/v1/me                      # Update profile
GET    /api/v1/me/components           # My components
POST   /api/v1/components              # Create component
PATCH  /api/v1/components/:id          # Update component
POST   /api/v1/components/:id/versions # Create version
GET    /api/v1/me/earnings             # My earnings
GET    /api/v1/me/payouts              # My payouts

# Enterprise endpoints
GET    /api/v1/organization            # My organization
GET    /api/v1/organization/licenses   # Our licenses
POST   /api/v1/licenses                # Purchase license
GET    /api/v1/organization/downloads  # Download history
```

---

## Implementation Phases

### Phase 1: Foundation (Weeks 1-4)

**Goals:** Basic Rails setup, authentication, and core models

- [ ] Initialize Rails 7 application
- [ ] Set up PostgreSQL database
- [ ] Configure Devise authentication
- [ ] Implement user registration (developer/enterprise)
- [ ] Create core database migrations
- [ ] Set up basic layouts and styling
- [ ] Implement user profiles

**Deliverables:**
- Working authentication system
- User can sign up as developer or enterprise
- Basic navigation and UI shell

### Phase 2: Component Marketplace (Weeks 5-8)

**Goals:** Component listing, search, and developer submissions

- [ ] Implement component CRUD for developers
- [ ] File upload with Active Storage
- [ ] Category system
- [ ] Component search (basic)
- [ ] Public component pages
- [ ] Version management
- [ ] Developer public profiles

**Deliverables:**
- Developers can publish components
- Public marketplace browsing
- Component detail pages

### Phase 3: Enterprise Features (Weeks 9-12)

**Goals:** Organizations, subscriptions, and licensing

- [ ] Organization model and management
- [ ] Team invitations
- [ ] Stripe integration for subscriptions
- [ ] Subscription plan selection
- [ ] Commercial license purchases
- [ ] License key generation
- [ ] Download tracking

**Deliverables:**
- Enterprises can subscribe to plans
- Purchase commercial licenses
- Manage team access

### Phase 4: Payments & Payouts (Weeks 13-16)

**Goals:** Developer earnings and payment processing

- [ ] Stripe Connect integration
- [ ] Developer onboarding to Stripe
- [ ] Transaction recording
- [ ] 85/15 revenue split logic
- [ ] Developer earnings dashboard
- [ ] Automated payouts
- [ ] Payout history

**Deliverables:**
- Developers receive payouts
- Complete financial tracking
- Revenue analytics

### Phase 5: Admin Panel (Weeks 17-20)

**Goals:** Full administrator functionality

- [ ] Admin namespace and authentication
- [ ] Admin dashboard with metrics
- [ ] User management (CRUD, suspend, impersonate)
- [ ] Component moderation
- [ ] Financial reports
- [ ] Subscription management
- [ ] System configuration

**Deliverables:**
- Complete admin panel
- Platform management capabilities

### Phase 6: Polish & Launch (Weeks 21-24)

**Goals:** Testing, optimization, and launch readiness

- [ ] Comprehensive test suite
- [ ] Performance optimization
- [ ] Security audit
- [ ] Email notifications
- [ ] Documentation
- [ ] Deployment setup (staging/production)
- [ ] Monitoring and alerting

**Deliverables:**
- Production-ready application
- Deployed to staging/production

---

## Routes Overview

```ruby
# config/routes.rb

Rails.application.routes.draw do
  # Authentication
  devise_for :users

  # Public pages
  root 'home#index'
  get 'about', to: 'pages#about'
  get 'pricing', to: 'pages#pricing'

  # Public marketplace
  resources :components, only: [:index, :show], param: :slug
  resources :categories, only: [:index, :show], param: :slug
  resources :developers, only: [:show], param: :username

  # Developer area
  namespace :developers do
    resource :dashboard, only: [:show]
    resources :components do
      resources :versions
    end
    resource :earnings, only: [:show]
    resources :payouts, only: [:index, :show]
    resource :profile, only: [:show, :edit, :update]
    resource :stripe_account, only: [:new, :create, :show]
  end

  # Enterprise area
  namespace :enterprises do
    resource :dashboard, only: [:show]
    resource :organization, only: [:show, :edit, :update]
    resources :members, only: [:index, :create, :destroy]
    resources :invitations, only: [:create, :destroy]
    resource :subscription, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :licenses, only: [:index, :show, :new, :create]
    resources :downloads, only: [:index]
  end

  # Admin area
  namespace :admin do
    root 'dashboard#index'
    resources :users
    resources :organizations
    resources :components do
      member do
        post :approve
        post :reject
        post :feature
      end
    end
    resources :categories
    resources :subscriptions
    resources :transactions, only: [:index, :show]
    resources :payouts, only: [:index, :show, :update]
    resources :reviews, only: [:index, :show, :destroy]
    resource :settings, only: [:show, :update]
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :components, only: [:index, :show], param: :slug do
        resources :versions, only: [:index, :show]
      end
      resources :categories, only: [:index]
      resource :me, only: [:show, :update]
      # ... additional API routes
    end
  end

  # Webhooks
  post 'webhooks/stripe', to: 'webhooks#stripe'
end
```

---

## Key Gems

```ruby
# Gemfile

# Core
gem 'rails', '~> 7.1'
gem 'pg'
gem 'puma'

# Authentication & Authorization
gem 'devise'
gem 'omniauth-github'
gem 'pundit'

# Payments
gem 'stripe'

# Background Jobs
gem 'sidekiq'
gem 'sidekiq-scheduler'

# Frontend
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'

# File Upload
gem 'aws-sdk-s3'
gem 'image_processing'

# Search
gem 'pg_search'  # or 'searchkick' for Elasticsearch

# Admin
gem 'pagy'       # Pagination

# Utilities
gem 'friendly_id'    # Slugs
gem 'aasm'           # State machines
gem 'money-rails'    # Money handling
gem 'noticed'        # Notifications

# Development & Testing
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop-rails'
end
```

---

## Next Steps

1. **Review this plan** and adjust based on priorities
2. **Initialize Rails application** with `rails new nightmoves --database=postgresql`
3. **Set up development environment** (Docker, PostgreSQL, Redis)
4. **Begin Phase 1** implementation

---

## File Organization Summary

```
NightMoves/
├── README.md                 # Project overview
├── docs/
│   ├── IMPLEMENTATION_PLAN.md   # This document
│   ├── business/
│   │   ├── nightmoves_business_model.md
│   │   ├── nightmoves_governance_charter.md
│   │   ├── nightmoves_licensing_framework.md
│   │   └── nightmoves_research.md
│   └── financial/
│       ├── financial_projections.py
│       ├── nightmoves_financial_projections.csv
│       └── nightmoves_financial_projections.png
└── [Rails application will be created here]
```
