CREATE TABLE admin (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(50) NULL,
    password VARCHAR(255)
);

CREATE TABLE stock_manager (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(50) NULL,
    password VARCHAR(255)
);

CREATE TABLE order_receiver (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(50) NULL,
    password VARCHAR(255)
);

CREATE TABLE supplier (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(50) NULL
);

CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(50) NULL,
    location TEXT
);

CREATE TABLE category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category_id INT,
    quantity INT DEFAULT 0,
    current_price DECIMAL(10,2) DEFAULT 0.00,
    image_url VARCHAR(100),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE purchase (
    id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    product_id INT,
    quantity INT DEFAULT 0,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    price_paid DECIMAL(10,2),
    total_price DECIMAL(10,2),
    status ENUM('pending', 'confirmed', 'processing', 'cancelled', 'shipped', 'delivered'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    price_per_unit DECIMAL(10,2),
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);