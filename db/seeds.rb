# Create admin user
admin = User.find_or_create_by!(email: "admin@nightmoves.dev") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "Admin"
  u.last_name = "User"
  u.role = :admin
end
puts "Created admin user: #{admin.email}"

# Create sample developer
developer = User.find_or_create_by!(email: "developer@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "Jane"
  u.last_name = "Developer"
  u.role = :developer
  u.bio = "Full-stack Ruby developer passionate about open source."
  u.github_username = "janedev"
end
puts "Created developer user: #{developer.email}"

# Create sample enterprise user
enterprise = User.find_or_create_by!(email: "enterprise@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "John"
  u.last_name = "Enterprise"
  u.role = :enterprise
end
puts "Created enterprise user: #{enterprise.email}"

# Create categories
categories_data = [
  { name: "Authentication", icon: "lock", description: "Authentication and authorization libraries" },
  { name: "API", icon: "code", description: "API building and integration tools" },
  { name: "Testing", icon: "check", description: "Testing frameworks and utilities" },
  { name: "Database", icon: "database", description: "Database tools and ORM extensions" },
  { name: "Frontend", icon: "layout", description: "Frontend integration and asset management" },
  { name: "Background Jobs", icon: "clock", description: "Background processing and job queues" },
  { name: "Payments", icon: "credit-card", description: "Payment processing integrations" },
  { name: "DevOps", icon: "server", description: "Deployment and infrastructure tools" }
]

categories = categories_data.map.with_index do |data, index|
  Category.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:description]
    c.icon = data[:icon]
    c.position = index
  end
end
puts "Created #{categories.count} categories"

# Create sample components
components_data = [
  {
    name: "SecureAuth",
    tagline: "Multi-factor authentication made simple",
    description: "A comprehensive authentication solution with MFA support, OAuth providers, and secure session management.",
    category: "Authentication",
    license_type: :mit,
    commercial_price_cents: 4999
  },
  {
    name: "APIBuilder",
    tagline: "Build beautiful REST APIs faster",
    description: "Convention-over-configuration API framework with automatic documentation, versioning, and rate limiting.",
    category: "API",
    license_type: :apache2,
    commercial_price_cents: 9999
  },
  {
    name: "TestMaster",
    tagline: "Testing utilities for Rails applications",
    description: "A collection of testing helpers, factories, and matchers to make your test suite more expressive.",
    category: "Testing",
    license_type: :mit,
    commercial_price_cents: 0
  }
]

components_data.each do |data|
  category = Category.find_by(name: data[:category])
  component = Component.find_or_create_by!(name: data[:name], developer: developer) do |c|
    c.tagline = data[:tagline]
    c.description = data[:description]
    c.category = category
    c.license_type = data[:license_type]
    c.commercial_price_cents = data[:commercial_price_cents]
    c.status = :published
    c.published_at = Time.current
    c.downloads_count = rand(100..5000)
    c.stars_count = rand(10..500)
  end

  # Create a version for each component
  ComponentVersion.find_or_create_by!(component: component, version: "1.0.0") do |v|
    v.changelog = "Initial release"
    v.status = :published
    v.published_at = Time.current
    v.downloads_count = component.downloads_count
  end
end
puts "Created #{components_data.count} sample components"

# Create sample organization for enterprise user
org = Organization.find_or_create_by!(name: "Acme Corp") do |o|
  o.description = "Building the future of software"
  o.website = "https://acme.example.com"
  o.billing_email = enterprise.email
end

OrganizationMembership.find_or_create_by!(organization: org, user: enterprise) do |m|
  m.role = :owner
end
puts "Created organization: #{org.name}"

puts "\n✅ Seed data created successfully!"
puts "\nTest accounts:"
puts "  Admin:      admin@nightmoves.dev / password123"
puts "  Developer:  developer@example.com / password123"
puts "  Enterprise: enterprise@example.com / password123"
