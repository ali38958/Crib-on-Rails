
# Crib on Rails - Complete Project Summary

## Overview
Inventory Management System built with Ruby on Rails 8.1.3

## Authentication System
- BCrypt password hashing (cost: 10)
- JWT tokens with refresh mechanism
- Two-token system:
  - Auth token (1 hour expiry)
  - Refresh token (7 days expiry)
- HTTP-only cookies
- Role-based access control (Admin, StockManager, OrderReceiver)

## Models
- Admin (custom string ID, has_secure_password, status: active/inactive)
- StockManager (custom string ID, has_secure_password, status: active/inactive)
- OrderReceiver (custom string ID, has_secure_password, status: active/inactive)
- Customer
- Supplier
- Category
- Product (with price change tracking)
- Purchase
- Order (status enum: pending, confirmed, processing, cancelled, shipped, delivered)
- OrderItem (quantity > 0, auto-sets price from product)
- PriceChange (tracks product price history)

## Pages & Features

### Login Page
- Custom design with dark theme, SVG curve, and brass accents
- Login with email OR custom string ID
- Checks users in order: OrderReceiver → StockManager → Admin
- Redirects to role-specific dashboard
- "Stay signed in" checkbox
- Password visibility toggle
- Auto-redirect if already logged in

### Admin Dashboard
- Overview stats: Total Items, Low Stock Alerts, Orders Today, Total Users
- Recent Orders table with status badges
- Quick access to Users management

### Admin Users Management
- View all users by role (Admins, Stock Managers, Order Receivers)
- Add new users via modal
- Edit existing users via modal
- Status toggle (active/inactive)
- Cannot change own status
- Modal with backdrop click and Escape key close
- Dark bordered table design

## CSS Architecture
- Modular CSS files:
  - `variables.css` - Global design tokens
  - `layout.css` - Header, sidebar, main content
  - `login.css` - Login page styles (only loads on login page)
  - `admin/users.css` - Users management styles
  - `admin/dashboard.css` - Dashboard styles
- Fonts: Fraunces (serif), Manrope (sans-serif), Space Mono (monospace)
- Brass/charcoal color scheme
- Collapsible sidebar (icons only / icons + text)
- Responsive mobile support

## Key Controllers
- `LoginController` - Login page, authentication, JWT generation
- `SessionsController` - Logout
- `RefreshController` - Token refresh endpoint
- `DashboardsController` - Role-based dashboard routing
- `Admin::DashboardController` - Admin dashboard
- `Admin::UsersController` - Full CRUD for users (no delete)
- `StockManager::DashboardController` - Stock manager dashboard
- `OrderReceiver::DashboardController` - Order receiver dashboard

## Routes
```
GET    /login              - Login page
POST   /login              - Login form submission
POST   /refresh            - Refresh auth token
GET    /logout             - Logout
DELETE /logout             - Logout
GET    /dashboard          - Redirect to role dashboard

Admin:
GET    /admin              - Admin dashboard
GET    /admin/users        - User management
GET    /admin/users/new/:role - New user modal
POST   /admin/users        - Create user
GET    /admin/users/:id/edit/:role - Edit user modal
PATCH  /admin/users/:id    - Update user

Stock Manager:
GET    /stock_manager      - Dashboard
GET    /stock_manager/orders - Orders

Order Receiver:
GET    /order_receiver     - Dashboard
GET    /order_receiver/orders - Orders
```

## Test Credentials
```
Admin:
  ID: ADMIN001
  Email: admin@example.com
  Password: password123

StockManager:
  ID: SM001
  Email: stock@example.com
  Password: password123

OrderReceiver:
  ID: OR001
  Email: order@example.com
  Password: password123
```

## Environment Variables (.env)
```
SECRET_KEY_BASE=45ecr6tforc4ib0nra1l5
REFRESH_KEY_BASE=3h1s1saf0c7in9refr9shtok3n415ga
AUTH_TOKEN_LIFE=3600
REFRESH_TOKEN_LIFE=604800
```

## Key Gems
- bcrypt - Password hashing
- jwt - JSON Web Tokens
- dotenv-rails - Environment variables

## File Structure
```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── login_controller.rb
│   ├── refresh_controller.rb
│   ├── sessions_controller.rb
│   ├── dashboards_controller.rb
│   ├── admin/
│   │   ├── base_controller.rb
│   │   ├── dashboard_controller.rb
│   │   └── users_controller.rb
│   ├── stock_manager/
│   │   ├── base_controller.rb
│   │   └── dashboard_controller.rb
│   └── order_receiver/
│       ├── base_controller.rb
│       └── dashboard_controller.rb
├── views/
│   ├── layouts/application.html.erb
│   ├── login/index.html.erb
│   ├── admin/dashboard/index.html.erb
│   ├── admin/users/index.html.erb
│   ├── admin/users/_form.html.erb
│   ├── stock_manager/dashboard/index.html.erb
│   └── order_receiver/dashboard/index.html.erb
├── helpers/auth_helper.rb
└── assets/stylesheets/
    ├── application.css
    ├── variables.css
    ├── layout.css
    ├── login.css
    └── admin/
        ├── dashboard.css
        └── users.css
```

## Notes
- Used Propshaft for asset pipeline (Rails 8 default)
- Custom CSS with dark theme
- No Bootstrap/Tailwind - pure custom design
- AJAX modals for user management
- Auto-refresh token mechanism for seamless session