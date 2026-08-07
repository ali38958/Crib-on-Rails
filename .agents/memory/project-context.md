---
type: project
created: 2026-08-07
updated: 2026-08-07
---

# Codebase Context: Crib_on_Rails

## Application Structure
- **Framework:** Ruby on Rails 8.1
- **Primary Namespaces / Dashboards:**
  - `Admin`: User management (Admin, StockManager, OrderReceiver).
  - `Stock Manager`: Manages Suppliers, Purchases, Products, and Categories.
  - `Order Receiver`: Manages Customers, Orders (launch, create, update status/price).

## Database Schema (Key Models)
- `Admin`, `StockManager`, `OrderReceiver` - Dedicated tables for user roles.
- `Category`, `Product` - Inventory management. Products belong to Categories.
- `Customer`, `Order`, `OrderItem` - Sales flow. Orders belong to Customers and have many OrderItems (which link to Products).
- `Supplier`, `Purchase` - Sourcing flow. Purchases link Suppliers and Products.
- `PriceChange`, `StatusChange` - Audit and history tracking.
- `ActiveStorage` - Handling image attachments for products.

## Core Functionalities
- **Authentication:** `login#index`, `sessions#destroy`, custom session management.
- **Routing:** Namespaced architectures matching the user roles. Root directs to login.
