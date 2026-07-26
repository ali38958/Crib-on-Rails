# 1. Admin (with custom string ID - generate then edit migration)
rails generate model Admin name:string phone:string email:string password:string

# 2. Stock Manager
rails generate model StockManager name:string phone:string email:string password:string

# 3. Order Receiver
rails generate model OrderReceiver name:string phone:string email:string password:string

# 4. Supplier (normal auto-increment ID)
rails generate model Supplier name:string phone:string email:string

# 5. Customer
rails generate model Customer name:string phone:string email:string location:text

# 6. Category
rails generate model Category name:string

# 7. Product
rails generate model Product name:string category:references quantity:integer current_price:decimal image_url:string

# 8. Purchase
rails generate model Purchase supplier:references product:references quantity:integer total_price:decimal

# 9. Order
rails generate model Order customer:references price_paid:decimal total_price:decimal status:integer

# 10. OrderItem
rails generate model OrderItem order:references product:references price_per_unit:decimal quantity:integer