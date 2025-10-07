DROP DATABASE IF exists SWP391;
CREATE DATABASE IF NOT EXISTS SWP391;
use SWP391;

CREATE TABLE roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  role_name varchar(50) UNIQUE NOT NULL,
  description text
);

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username varchar(50),
  password varchar(255),
  email varchar(100),
  image_url varchar(255),
  full_name varchar(100),
  phone varchar(20),
  role_id int,
  status enum('active','inactive') DEFAULT 'active',
  date timestamp default current_timestamp,
  foreign key (role_id) references roles(id)
);

CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL
);

CREATE TABLE devices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  unit varchar(50),
  image_url varchar(255),
  type enum('spare part','device'),
  created_at timestamp default current_timestamp,
  foreign key (category_id) references categories(id)
);

CREATE TABLE suppliers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  address VARCHAR(255)
);

CREATE TABLE supplier_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_id INT NOT NULL,
  device_id INT NOT NULL,
  date timestamp default current_timestamp,
  price DECIMAL(10,2) NOT NULL,
  foreign key (supplier_id) references suppliers(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE inventories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  storekeeper_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  foreign key (storekeeper_id) references users(id)
);

CREATE TABLE device_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  inventory_id INT NOT NULL,
  device_id INT NOT NULL,
  description text,
  serial_no varchar(100),
  status ENUM('in_stock','out_stock','sold'),
  foreign key (inventory_id) references inventories(id)
);


CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
  date timestamp default current_timestamp,
  foreign key (customer_id) references users(id)
);

CREATE TABLE order_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  discount DECIMAL(5,2),
  warranty_date timestamp,
  foreign key (order_id) references orders(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT UNIQUE NOT NULL,
  payment_url varchar(255),
  status ENUM('pending','success','failed') DEFAULT 'pending',
  created_at timestamp default current_timestamp,
  updated_at timestamp,
  foreign key (order_id) references orders(id)
);

CREATE TABLE tasks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  manager_id INT NOT NULL,
  foreign key (manager_id) references users(id)
);

CREATE TABLE task_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  task_id INT NOT NULL,
  technical_staff_id INT NOT NULL,
  assigned_at timestamp default current_timestamp,
  deadline timestamp,
  status ENUM('pending','in_progress','completed','cancelled') DEFAULT 'pending',
  foreign key (task_id) references tasks(id),
  foreign key (technical_staff_id) references users(id)
);

CREATE TABLE customer_issues (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP default current_timestamp,
  foreign key (customer_id) references users(id)
);

CREATE TABLE customer_issue_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  issue_id INT NOT NULL,
  staff_id INT NOT NULL,
  role ENUM('main','assistant') DEFAULT 'assistant',
  status ENUM('pending','in_progress','resolved','cancelled') DEFAULT 'pending',
  updated_at timestamp default current_timestamp,
  foreign key (issue_id) references customer_issues(id),
  foreign key (staff_id) references users(id)
);

CREATE TABLE transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  storekeeper_id INT NOT NULL,
  technical_staff_id INT NOT NULL,
  date timestamp default current_timestamp,
  type ENUM('export','import') NOT NULL,
  status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
  foreign key (storekeeper_id) references users(id),
  foreign key (technical_staff_id) references users(id)
);

CREATE TABLE transaction_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  transaction_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  foreign key (transaction_id) references transactions(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE permissions (
	id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE role_permission (
	id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    foreign key (role_id) references roles (id),
    foreign key (permission_id) references permissions(id),
    UNIQUE (role_id, permission_id)
);

CREATE TABLE user_permission (
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    permission_id INT NOT NULL,
    foreign key (user_id) references users(id),
    foreign key (permission_id) references permissions(id),
    UNIQUE (user_id, permission_id)
);

INSERT INTO roles (role_name, description) VALUES
('Admin', 'System administrator'),
('Technical Manager', 'Manages technical staff and tasks'),
('Technical Staff', 'Handles technical tasks'),
('Customer Support Staff', 'Handles support request of customer'),
('Storekeeper', 'Manages inventory'),
('Customer', 'End users who order devices');

INSERT INTO users (username, password, email, image_url, full_name, phone, role_id, status) VALUES
('admin01', '123456', 'admin@example.com', NULL, 'System Admin', '0901234567', 1, 'active'),
('manager01', '123456', 'manager@example.com', NULL, 'Van Son', '0902345678', 2, 'active'),
('techstaff01', '123456', 'staff01@example.com', NULL, 'Duc Nguyen', '0903456789', 3, 'active'),
('spstaff01', '123456', 'spstaff01@example.com', NULL, 'Xuan Bac', '0904567890', 4, 'active'),
('storekeeper01', '123456', 'storekeeper@example.com', NULL, 'Hai Dang', '0905678901', 5, 'active'),
('customer01', '123456', 'customer01@example.com', NULL, 'Hieu Pham', '0906789012', 6, 'active'),
('customer02', '123456', 'customer02@example.com', NULL, 'Customer', '0907890123', 6, 'active');

INSERT INTO categories (category_name) VALUES
('Laptop'),
('Smartphone'),
('Printer'),
('Spare Parts');

INSERT INTO devices (category_id, name, price, unit, image_url, type) VALUES
(1, 'Dell XPS 13', 1200.00, 'pcs', NULL, 'device'),
(1, 'MacBook Pro 14', 2200.00, 'pcs', NULL, 'device'),
(2, 'iPhone 15', 999.00, 'pcs', NULL, 'device'),
(2, 'Samsung Galaxy S24', 899.00, 'pcs', NULL, 'device'),
(4, 'Laptop Charger 65W', 45.00, 'pcs', NULL, 'spare part'),
(4, 'iPhone Case', 20.00, 'pcs', NULL, 'spare part');

INSERT INTO suppliers (name, phone, email, address) VALUES
('TechSupplier Ltd.', '0901111222', 'sales@techsupplier.com', '123, Thach Hoa, Thach That, Ha Noi'),
('MobileWorld Co.', '0902222333', 'contact@mobileworld.com', '456, Thach Hoa, Thach That, Ha Noi');

INSERT INTO supplier_details (supplier_id, device_id, price) VALUES
(1, 1, 1150.00),
(1, 5, 40.00),
(2, 3, 950.00),
(2, 6, 18.00);

INSERT INTO inventories (storekeeper_id, device_id, quantity) VALUES
(5, 1, 10),
(5, 2, 5),
(5, 3, 20),
(5, 4, 15),
(5, 5, 50),
(5, 6, 100);

INSERT INTO device_details (inventory_id, device_id, description, serial_no, status) VALUES
(1, 1, 'Dell XPS 13 2024 Model', 'SNXPS001', 'in_stock'),
(2, 2, 'MacBook Pro 14 M2', 'SNMBP002', 'in_stock'),
(3, 3, 'iPhone 15 Black', 'SNIP015', 'in_stock'),
(4, 4, 'Samsung Galaxy S24 White', 'SNSAM024', 'in_stock');

INSERT INTO orders (customer_id, total_amount, status) VALUES
(6, 999.00, 'confirmed'),
(7, 2200.00, 'pending');

INSERT INTO order_details (order_id, device_id, quantity, price, discount, warranty_date) VALUES
(1, 3, 1, 999.00, 0.00, '2026-09-28 00:00:00'),
(2, 2, 1, 2200.00, 0.00, '2027-09-28 00:00:00');

INSERT INTO payments (order_id, payment_url, status) VALUES
(1, Null, 'success'),
(2, Null, 'pending');

INSERT INTO tasks (title, description, manager_id) VALUES
('Setup new laptops', 'Prepare laptops for new staff', 2),
('Fix printer issue', 'Resolve error E05 in printer', 2);

INSERT INTO task_details (task_id, technical_staff_id, deadline, status) VALUES
(1, 3, '2025-10-05 00:00:00', 'in_progress'),
(2, 4, '2025-10-10 00:00:00', 'pending');

INSERT INTO customer_issues (customer_id, title, description) VALUES
(6, 'Laptop overheating', 'Laptop gets very hot after 30 minutes'),
(7, 'Phone battery issue', 'Battery drains too fast on Galaxy S24');

INSERT INTO transactions (storekeeper_id, technical_staff_id, type, status) VALUES
(5, 3, 'export', 'confirmed'),
(5, 4, 'import', 'pending');

INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES
(1, 1, 2),
(2, 5, 10);

INSERT INTO permissions (id, permission_name) VALUES
(1, 'CREATE_TASK'),
(2, 'VIEW_TASK_LIST'),
(3, 'UPDATE_TASK'),
(4, 'DELETE_TASK'),
(5, 'ASSIGN_TASK'),
(6, 'UNASSIGN_TASK'),

(7, 'CREATE_ACCOUNT'),
(8, 'VIEW_ACCOUNT'),
(9, 'UPDATE_ACCOUNT'),
(10, 'ACTIVE_ACCOUNT'),
(11, 'DEACTIVE_ACCOUNT'),

(12, 'CATEGORY_MANAGEMENT'),
(13, 'PRODUCT_CATALOG_MANAGEMENT'),
(14, 'PRODUCT_OVERVIEW'),
(15, 'PRICING_MANAGEMENT'),

(16, 'CREATE_IMPORT_EXPORT_ORDER'),
(17, 'QUANTITY_CHECK'),
(18, 'IMPORT_EXPORT_REPORTS'),

(19, 'CRUD_SUPPLIER'),
(20, 'PRODUCT_SUPPLY_MANAGEMENT'),
(21, 'SUPPLIER_INFORMATION_MANAGEMENT'),
(22, 'SUPPLIER_INFO_INTEGRATION'),

(23, 'ORDER_VALIDATION'),
(24, 'CRUD_ORDER'),
(25, 'ORDER_TRACKING'),
(26, 'ORDER_REPORTS'),

(27, 'INTEGRATION_PAYOS'),
(28, 'PAYMENT_REPORTS'),
(29, 'PAYMENT_CONFIRMATION'),
(30, 'PAYMENT_REQUEST_CREATION'),

(31, 'REVENUE_PROFIT_ANALYSIS'),
(32, 'CUSTOMER_ORDER_REPORT'),
(33, 'SALE_REPORTS'),
(34, 'INVENTORY_REPORTS'),

(35, 'CUSTOMER_ISSUES_RESPONDING'),
(36, 'CUSTOMER_ISSUES_MANAGEMENT'),
(37, 'CUSTOMER_ISSUES');

-- Admin
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Technical Manager
INSERT INTO role_permission (role_id, permission_id) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(2, 12), (2, 13), (2, 14), (2, 15),
(2, 19), (2, 20), (2, 21), (2, 22),
(2, 23), (2, 24), (2, 25), (2, 26),
(2, 28),
(2, 31), (2, 32), (2, 33), (2, 34),
(2, 36)
;

-- Technical Staff
INSERT INTO role_permission (role_id, permission_id) VALUES
(3, 2), 
(3, 3),
(3, 14),
(3, 16), 
(3, 36)
;

-- Customer Support Staff
INSERT INTO role_permission (role_id, permission_id) VALUES
(4, 14),
(4, 23), (4, 25), (4, 26),
(4, 35), (4, 36)
;

-- Storekeeper
INSERT INTO role_permission (role_id, permission_id) VALUES
(5, 12), (5, 13), (5, 14), (5, 15), 
(5, 16), (5, 17), (5, 18), 
(5, 23), (5, 24), (5, 25), (5, 26),
(5, 28),
(5, 31), (5, 32), (5, 33), (5, 34)
;

-- Customer
INSERT INTO role_permission (role_id, permission_id) VALUES
(6, 14), 
(6, 24), (6, 25), (6, 26),
(6, 27), (6, 30),
(6, 37)
;

