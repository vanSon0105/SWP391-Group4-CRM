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
  username varchar(50) UNIQUE,
  password varchar(255),
  email varchar(100) UNIQUE,
  image_url varchar(255),
  full_name varchar(100),
  phone varchar(20),
  role_id int,
  status enum('active','inactive') DEFAULT 'active',
  created_at timestamp default current_timestamp,
  last_login_at timestamp,
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
  description text,
  created_at timestamp default current_timestamp,
  is_featured BOOLEAN DEFAULT FALSE,
  foreign key (category_id) references categories(id)
);

create table device_serials(
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL,
  serial_no VARCHAR(100) UNIQUE,
  status ENUM('in_stock', 'sold', 'in_repair', 'out_stock') DEFAULT 'in_stock',
  import_date TIMESTAMP,
  foreign key (device_id) references devices(id)
);

CREATE TABLE inventories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  storekeeper_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  foreign key (storekeeper_id) references users(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
  date timestamp default current_timestamp,
  foreign key (customer_id) references users(id)
);

CREATE TABLE warranty_cards(
	id INT PRIMARY KEY AUTO_INCREMENT,
    device_serial_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    start_at TIMESTAMP ,
    end_at TIMESTAMP,
    foreign key (device_serial_id) references device_serials(id),
    foreign key (customer_id) references users(id)
);

CREATE TABLE order_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  device_id INT NOT NULL,
  device_serial_id INT NOT NULL UNIQUE,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  discount DECIMAL(5,2),
  warranty_card_id INT NOT NULL UNIQUE,
  foreign key (order_id) references orders(id),
  foreign key (device_id) references devices(id),
  foreign key (warranty_card_id) references warranty_cards(id),
  foreign key (device_serial_id) references device_serials(id)
);


CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT UNIQUE NOT NULL,
  payment_url varchar(255),
  status ENUM('pending','success','failed') DEFAULT 'pending',
  created_at timestamp default current_timestamp,
  paid_at timestamp,
  foreign key (order_id) references orders(id)
);

CREATE TABLE customer_issues (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  issue_code VARCHAR(50) UNIQUE,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  warranty_card_id INT,
  created_at TIMESTAMP default current_timestamp,
  foreign key (customer_id) references users(id),
  foreign key (warranty_card_id) references warranty_cards(id)
);

CREATE TABLE tasks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  manager_id INT NOT NULL,
  customer_issue_id INT not null,
  foreign key (manager_id) references users(id),
  foreign key (customer_issue_id) references customer_issues(id)
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

CREATE TABLE transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  storekeeper_id INT NOT NULL,
  user_id INT,
  supplier_id INT,
  date timestamp default current_timestamp,
  type ENUM('export','import') NOT NULL,
  status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
  foreign key (storekeeper_id) references users(id),
  foreign key (user_id) references users(id),
  foreign key (supplier_id) references suppliers(id)
);

ALTER TABLE transactions
  ADD CONSTRAINT chk_type_refs
  CHECK (
    (type = 'import' AND supplier_id IS NOT NULL AND user_id IS NULL) OR
    (type = 'export' AND user_id IS NOT NULL AND supplier_id IS NULL)
  );

CREATE TABLE transaction_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  transaction_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  foreign key (transaction_id) references transactions(id),
  foreign key (device_id) references devices(id)
);

create table carts(
  id INT PRIMARY KEY AUTO_INCREMENT,
  sum INT,
  user_id INT NOT NULL,
  foreign key (user_id) references users(id)
);

create table cart_details(
  id INT PRIMARY KEY AUTO_INCREMENT,
  price DECIMAL(10,2) NOT NULL,
  quantity INT not null,
  cart_id INT not null,
  device_id INT not null,
  foreign key (cart_id) references carts(id),
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
('customer02', '123456', 'customer02@example.com', NULL, 'Customer', '0907890123', 6, 'active'),
('customer03', '123456', 'customer03@example.com', NULL, 'Nguyen An',  '0908000003', 6, 'active'),
('customer04', '123456', 'customer04@example.com', NULL, 'Tran Binh',  '0908000004', 6, 'active'),
('customer05', '123456', 'customer05@example.com', NULL, 'Le Chi',     '0908000005', 6, 'active'),
('customer06', '123456', 'customer06@example.com', NULL, 'Pham Duong', '0908000006', 6, 'active'),
('customer07', '123456', 'customer07@example.com', NULL, 'Hoai Giang', '0908000007', 6, 'active');

INSERT INTO categories (category_name) VALUES
('Laptop'),
('Smartphone'),
('Printer'),
('Spare Parts');

INSERT INTO devices (category_id, name, price, unit, image_url, description) VALUES
(1, 'Dell XPS 13',                 1200.00, 'pcs', NULL, '13" ultrabook, Intel Core, 16GB RAM, 512GB SSD, ~1.2kg; phù hợp di động/doanh nhân.'),
(1, 'MacBook Pro 14',              2200.00, 'pcs', NULL, '14" laptop Apple Silicon, màn Liquid Retina XDR, thời lượng pin dài; máy trạm sáng tạo.'),
(2, 'iPhone 15',                    999.00, 'pcs', NULL, 'Smartphone 6.1", chip A16, camera cải thiện, sạc USB-C; flagship cân bằng hiệu năng.'),
(2, 'Samsung Galaxy S24',           899.00, 'pcs', NULL, 'Flagship 6.2", màn AMOLED 120Hz, Exynos/Snapdragon, AI features; chụp ảnh mạnh.'),
(4, 'Laptop Charger 65W',            45.00, 'pcs', NULL, 'Sạc laptop 65W (DC/USB-C tuỳ mẫu), bảo vệ quá dòng/quá nhiệt; phù hợp đa số ultrabook.'),
(4, 'iPhone Case',                   20.00, 'pcs', NULL, 'Ốp bảo vệ silicon/TPU, chống trầy xước, bám tay tốt; viền nhô bảo vệ camera/màn hình.'),
(3, 'HP LaserJet Pro M404',         320.00, 'pcs', NULL, 'Máy in laser đơn sắc A4, ~38 ppm, kết nối USB/Ethernet; in văn phòng bền bỉ.'), 
(3, 'Canon Pixma G3020',            250.00, 'pcs', NULL, 'Máy in phun bình mực liên tục (G-Series), in màu, Wi-Fi, copy/scan; chi phí trang thấp.'), 
(1, 'Lenovo ThinkPad X1 Carbon',   1850.00, 'pcs', NULL, '14" business ultralight, khung carbon, bàn phím ThinkPad, nhiều cổng; bền đạt chuẩn MIL-STD.'), 
(1, 'ASUS ROG Zephyrus G14',       1900.00, 'pcs', NULL, '14" gaming mỏng nhẹ, Ryzen + GeForce RTX, màn 120–165Hz; cân bằng game/đồ hoạ.'), 
(2, 'Samsung Galaxy Tab S9',        799.00, 'pcs', NULL, 'Tablet AMOLED ~11", S Pen kèm, DeX, IP68; ghi chú và giải trí tốt.'),  
(2, 'iPad Air (5th Gen)',           599.00, 'pcs', NULL, 'Tablet 10.9" chip M1, Apple Pencil/Keyboard, màn Liquid Retina; tối ưu học tập/sáng tạo.'), 
(4, 'Printer Toner Cartridge',       35.00, 'pcs', NULL, 'Hộp mực laser tương thích M404, năng suất ~3.000 trang; dễ thay thế, mực đều.'),
(4, 'USB-C Cable 1m',                 9.00, 'pcs', NULL, 'Cáp USB-C to C 1m, sạc đến 60W/3A, truyền dữ liệu; lõi bền, đầu nối chắc.');

INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES
(1, 3, 'IP15-SN0001', 'sold', '2025-09-01 00:00:00'),
(2, 2, 'MBP14-SN0001', 'sold', '2025-09-01 00:00:00'),
(3, 4, 'S24-SN0001', 'sold', '2025-09-01 00:00:00'),
(4, 2, 'MBP14-SN0002', 'sold', '2025-09-01 00:00:00'),
(5, 6, 'CASE-SN0001', 'sold', '2025-09-01 00:00:00'),
(6, 1, 'XPS13-SN0001', 'sold', '2025-09-01 00:00:00'),
(7, 5, 'CHARGER-SN0001', 'sold', '2025-09-01 00:00:00'),
(8, 7, 'HP404-SN0001', 'sold', '2025-09-01 00:00:00'),
(9, 9, 'TPX1-SN0001', 'sold', '2025-09-01 00:00:00'),
(10, 12, 'IPAD-AIR-SN0001', 'sold', '2025-09-01 00:00:00'),
(11, 3, 'IP15-SN0002', 'sold', '2025-09-01 00:00:00'),
(12, 11, 'TABS9-SN0001', 'sold', '2025-09-01 00:00:00'),
(13, 14, 'USBC-SN0001', 'sold', '2025-09-01 00:00:00'),
(14, 10, 'ROG-G14-SN0001', 'sold', '2025-09-01 00:00:00'),
(15, 14, 'USBC-SN0002', 'sold', '2025-09-01 00:00:00'),
(16, 13, 'TONER-SN0001', 'sold', '2025-09-01 00:00:00'),
(17, 13, 'TONER-SN0002', 'sold', '2025-09-01 00:00:00'),
(18, 7, 'HP404-SN0002', 'sold', '2025-09-01 00:00:00'),
(19, 3, 'IP15-SN0003', 'sold', '2025-09-01 00:00:00'),
(20, 2, 'MBP14-SN0003', 'sold', '2025-09-01 00:00:00'),
(21, 1, 'XPS13-SN0002', 'sold', '2025-09-01 00:00:00'),
(22, 6, 'CASE-SN0002', 'sold', '2025-09-01 00:00:00'),
(23, 8, 'CANON-G3020-SN0001', 'sold', '2025-09-01 00:00:00'),
(24, 7, 'HP404-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(25, 11, 'TABS9-SN0002', 'sold', '2025-09-01 00:00:00'),
(26, 14, 'USBC-SN0003', 'sold', '2025-09-01 00:00:00'),
(27, 9, 'TPX1-SN0002', 'sold', '2025-09-01 00:00:00'),
(28, 3, 'IP15-SN0004', 'sold', '2025-09-01 00:00:00'),
(29, 5, 'CHARGER-SN0002', 'sold', '2025-09-01 00:00:00'),
(30, 4, 'S24-SN0002', 'sold', '2025-09-01 00:00:00'),
(31, 12, 'IPAD-AIR-SN0002', 'sold', '2025-09-01 00:00:00'),
(32, 6, 'CASE-SN0003', 'sold', '2025-09-01 00:00:00');

INSERT INTO suppliers (name, phone, email, address) VALUES
('TechSupplier Ltd.', '0901111222', 'sales@techsupplier.com', '123, Thach Hoa, Thach That, Ha Noi'),
('MobileWorld Co.', '0902222333', 'contact@mobileworld.com', '456, Thach Hoa, Thach That, Ha Noi');

INSERT INTO supplier_details (supplier_id, device_id, price) VALUES
(1, 7, 290.00),
(1, 9, 1750.00),
(1, 13, 30.00),
(2, 8, 230.00),
(2, 10, 1820.00),
(2, 11, 760.00),
(2, 12, 560.00),
(2, 14, 7.50);

INSERT INTO inventories (storekeeper_id, device_id, quantity) VALUES
(5, 7, 12),
(5, 8, 10),
(5, 9, 6),
(5, 10, 5),
(5, 11, 15),
(5, 12, 18),
(5, 13, 80),
(5, 14, 200);

INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES
(1, 6, 999.00, 'confirmed', '2025-09-15 14:30:00'),
(2, 7, 2200.00, 'pending', '2025-09-15 14:30:00'),
(3,  8,  899.00,  'confirmed', '2025-09-12 10:00:00'),
(4,  9, 2220.00,  'confirmed', '2025-09-15 14:30:00'),
(5, 10, 1245.00,  'confirmed', '2025-09-18 09:15:00'),
(6, 11,  320.00,  'confirmed', '2025-09-20 11:45:00'),
(7, 12, 1850.00,  'pending',   '2025-09-22 16:00:00'),
(8,  6,  599.00,  'confirmed', '2025-09-24 18:10:00'),
(9,  7,  999.00,  'confirmed', '2025-09-25 08:20:00'),
(10, 8,  829.00,  'confirmed', '2025-09-26 13:05:00'),
(11, 9, 1935.00,  'confirmed', '2025-09-27 15:40:00'), 
(12,10,  355.00,  'confirmed', '2025-09-28 17:55:00'), 
(13,11, 2799.00,  'confirmed', '2025-09-29 10:22:00'), 
(14,12, 1218.00,  'pending',   '2025-09-30 19:45:00'),
(15, 6,  250.00,  'confirmed', '2025-10-01 09:02:00'), 
(16, 7,  320.00,  'cancelled', '2025-10-02 11:11:00'), 
(17, 8,  829.00,  'confirmed', '2025-10-03 12:34:00'),
(18, 9, 3099.00,  'confirmed', '2025-10-04 08:08:00'),  
(19,10,  899.00,  'confirmed', '2025-10-05 20:20:00'),
(20,11,  629.00,  'confirmed', '2025-10-06 07:07:00'); 

INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES
(1, 1, 6, '2025-09-28 00:00:00', '2026-09-28 00:00:00'),
(2, 2, 7, '2025-09-28 00:00:00', '2027-09-28 00:00:00'),
(3, 3, 8, '2025-09-12 10:00:00', '2027-09-12 10:00:00'),
(4, 4, 9, '2025-09-15 14:30:00', '2027-09-15 14:30:00'),
(5, 5, 9, '2025-09-15 14:30:00', '2026-03-15 14:30:00'),
(6, 6, 10, '2025-09-18 09:15:00', '2027-09-18 09:15:00'),
(7, 7, 10, '2025-09-18 09:15:00', '2026-03-18 09:15:00'),
(8, 8, 11, '2025-09-20 11:45:00', '2027-09-20 11:45:00'),
(9, 9, 12, '2025-09-22 16:00:00', '2027-09-22 16:00:00'),
(10, 10, 6, '2025-09-24 18:10:00', '2027-09-24 18:10:00'),
(11, 11, 7, '2025-09-25 08:20:00', '2027-09-25 08:20:00'),
(12, 12, 8, '2025-09-26 13:05:00', '2027-09-26 13:05:00'),
(13, 13, 8, '2025-09-26 13:05:00', '2026-03-26 13:05:00'),
(14, 14, 9, '2025-09-27 15:40:00', '2027-09-27 15:40:00'),
(15, 15, 9, '2025-09-27 15:40:00', '2026-03-27 15:40:00'),
(16, 16, 9, '2025-09-27 15:40:00', '2026-03-27 15:40:00'),
(17, 17, 10, '2025-09-28 17:55:00', '2026-03-28 17:55:00'),
(18, 18, 10, '2025-09-28 17:55:00', '2027-09-28 17:55:00'),
(19, 19, 11, '2025-09-29 10:22:00', '2027-09-29 10:22:00'),
(20, 20, 11, '2025-09-29 10:22:00', '2027-09-29 10:22:00'),
(21, 21, 12, '2025-09-30 19:45:00', '2027-09-30 19:45:00'),
(22, 22, 12, '2025-09-30 19:45:00', '2026-03-30 19:45:00'),
(23, 23, 6, '2025-10-01 09:02:00', '2027-10-01 09:02:00'),
(24, 24, 7, '2025-10-02 11:11:00', '2027-10-02 11:11:00'),
(25, 25, 8, '2025-10-03 12:34:00', '2027-10-03 12:34:00'),
(26, 26, 8, '2025-10-03 12:34:00', '2026-04-03 12:34:00'),
(27, 27, 9, '2025-10-04 08:08:00', '2027-10-04 08:08:00'),
(28, 28, 9, '2025-10-04 08:08:00', '2027-10-04 08:08:00'),
(29, 29, 9, '2025-10-04 08:08:00', '2026-04-04 08:08:00'),
(30, 30, 10, '2025-10-05 20:20:00', '2027-10-05 20:20:00'),
(31, 31, 11, '2025-10-06 07:07:00', '2027-10-06 07:07:00'),
(32, 32, 11, '2025-10-06 07:07:00', '2026-04-06 07:07:00');

INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES
(1, 3, 1, 1, 999.00, 0.00, 1),
(2, 2, 2, 1, 2200.00, 0.00, 2),
(3, 4, 3, 1, 899.00, 0.00, 3),
(4, 2, 4, 1, 2200.00, 0.00, 4),
(4, 6, 5, 1, 20.00, 0.00, 5),
(5, 1, 6, 1, 1200.00, 0.00, 6),
(5, 5, 7, 1, 45.00, 0.00, 7),
(6, 7, 8, 1, 320.00, 0.00, 8),
(7, 9, 9, 1, 1850.00, 0.00, 9),
(8, 12, 10, 1, 599.00, 0.00, 10),
(9, 3, 11, 1, 999.00, 0.00, 11),
(10, 11, 12, 1, 799.00, 0.00, 12),
(10, 14, 13, 1, 9.00, 0.00, 13),
(11, 10, 14, 1, 1900.00, 0.00, 14),
(11, 14, 15, 1, 9.00, 0.00, 15),
(11, 13, 16, 1, 26.00, 9.00, 16),
(12, 13, 17, 1, 35.00, 0.00, 17),
(12, 7, 18, 1, 320.00, 0.00, 18),
(13, 3, 19, 1, 999.00, 0.00, 19),
(13, 2, 20, 1, 2200.00, 0.00, 20),
(14, 1, 21, 1, 1200.00, 0.00, 21),
(14, 6, 22, 1, 18.00, 2.00, 22),
(15, 8, 23, 1, 250.00, 0.00, 23),
(16, 7, 24, 1, 320.00, 0.00, 24),
(17, 11, 25, 1, 799.00, 0.00, 25),
(17, 14, 26, 1, 9.00, 0.00, 26),
(18, 9, 27, 1, 1850.00, 0.00, 27),
(18, 3, 28, 1, 999.00, 0.00, 28),
(18, 5, 29, 1, 35.00, 0.00, 29),
(19, 4, 30, 1, 899.00, 0.00, 30),
(20, 12, 31, 1, 599.00, 30.00, 31),
(20, 6, 32, 1, 30.00, 30.00, 32);

INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES
(3,  NULL, 'success',  '2025-09-12 10:05:00', '2025-09-12 10:05:00'),
(4,  NULL, 'success',  '2025-09-15 14:35:00', '2025-09-15 14:35:00'),
(5,  NULL, 'success',  '2025-09-18 09:20:00', '2025-09-18 09:20:00'),
(6,  NULL, 'success',  '2025-09-20 11:50:00', '2025-09-20 11:50:00'),
(7,  NULL, 'pending',  '2025-09-22 16:05:00', NULL),
(8,  NULL, 'success',  '2025-09-24 18:15:00', '2025-09-24 18:15:00'),
(9,  NULL, 'success',  '2025-09-25 08:25:00', '2025-09-25 08:25:00'),
(10, NULL, 'success',  '2025-09-26 13:10:00', '2025-09-26 13:10:00'),
(11, NULL, 'success',  '2025-09-27 15:45:00', '2025-09-27 15:45:00'),
(12, NULL, 'success',  '2025-09-28 18:00:00', '2025-09-28 18:00:00'),
(13, NULL, 'success',  '2025-09-29 10:25:00', '2025-09-29 10:25:00'),
(14, NULL, 'pending',  '2025-09-30 19:50:00', NULL),
(15, NULL, 'success',  '2025-10-01 09:05:00', '2025-10-01 09:05:00'),
(16, NULL, 'failed',   '2025-10-02 11:15:00', '2025-10-02 11:20:00'),
(17, NULL, 'success',  '2025-10-03 12:40:00', '2025-10-03 12:40:00'),
(18, NULL, 'success',  '2025-10-04 08:12:00', '2025-10-04 08:12:00'),
(19, NULL, 'success',  '2025-10-05 20:25:00', '2025-10-05 20:25:00'),
(20, NULL, 'success',  '2025-10-06 07:10:00', '2025-10-06 07:10:00');

INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES
(1, 5, 6,  NULL, '2025-09-28 00:10:00', 'export', 'confirmed'),  
(2, 5, 7,  NULL, '2025-09-28 00:15:00', 'export', 'pending'),
(3, 5, 8,  NULL, '2025-09-12 10:06:00', 'export', 'confirmed'),
(4, 5, 9,  NULL, '2025-09-15 14:36:00', 'export', 'confirmed'),
(5, 5, 10, NULL, '2025-09-18 09:21:00', 'export', 'confirmed'),
(6, 5, 11, NULL, '2025-09-20 11:51:00', 'export', 'confirmed'),
(7, 5, 12, NULL, '2025-09-22 16:06:00', 'export', 'pending'),   
(8, 5, 6,  NULL, '2025-09-24 18:16:00', 'export', 'confirmed'),
(9, 5, 7,  NULL, '2025-09-25 08:26:00', 'export', 'confirmed'),
(10,5, 8,  NULL, '2025-09-26 13:11:00', 'export', 'confirmed'),
(11,5, 9,  NULL, '2025-09-27 15:46:00', 'export', 'confirmed'),
(12,5,10,  NULL, '2025-09-28 18:01:00', 'export', 'confirmed'),
(13,5,11,  NULL, '2025-09-29 10:26:00', 'export', 'confirmed'),
(14,5,12,  NULL, '2025-09-30 19:51:00', 'export', 'pending'),  
(15,5, 6,  NULL, '2025-10-01 09:06:00', 'export', 'confirmed'),
(16,5, 7,  NULL, '2025-10-02 11:16:00', 'export', 'cancelled'),  
(17,5, 8,  NULL, '2025-10-03 12:41:00', 'export', 'confirmed'),
(18,5, 9,  NULL, '2025-10-04 08:13:00', 'export', 'confirmed'),
(19,5,10,  NULL, '2025-10-05 20:26:00', 'export', 'confirmed'),
(20,5,11,  NULL, '2025-10-06 07:11:00', 'export', 'confirmed');

INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES
(1, 3, 1),
(2, 2, 1),
(3, 4, 1),
(4, 2, 1), (4, 6, 1),
(5, 1, 1), (5, 5, 1),
(6, 7, 1),
(7, 9, 1),
(8,12, 1),
(9, 3, 1),
(10,11, 1), (10,14, 1),
(11,10, 1), (11,14, 1), (11,13, 1),
(12,13, 1), (12,7, 1),
(13, 3, 1), (13,2, 1),
(14, 1, 1), (14,6, 1),
(15, 8, 1),
(16, 7, 1),
(17,11, 1), (17,14, 1),
(18, 9, 1), (18,3, 1), (18,5, 1),
(19, 4, 1),
(20,12, 1), (20,6, 1);

INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES
(101, 5, NULL, 1, '2025-09-10 09:00:00', 'import', 'confirmed'),
(102, 5, NULL, 2, '2025-09-16 09:00:00', 'import', 'confirmed');
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES
(101, 1, 5),  (101, 3, 10), (101, 13, 50),
(102, 2, 3),  (102, 11, 10), (102, 14, 100);

INSERT INTO customer_issues (customer_id, issue_code, title, description, warranty_card_id, created_at) VALUES
(6, 'ISS-0001', 'Máy nóng',     'iPhone 15 nóng khi sạc',           1, '2025-10-01 10:00:00'),
(7, 'ISS-0002', 'Pin yếu',      'iPhone 15 tụt pin nhanh',           11, '2025-10-02 11:00:00'),
(10,'ISS-0003', 'Kẹt giấy',     'HP LaserJet kẹt giấy thường xuyên', 18, '2025-10-03 09:30:00'),
(11,'ISS-0004', 'Màn hình sọc', 'iPad Air bị sọc dọc',              31, '2025-10-04 16:45:00');

INSERT INTO tasks (id, title, description, manager_id, customer_issue_id) VALUES
(1, 'Kiểm tra iPhone 15 nóng', 'Khách hàng Hieu Pham (ID 6) báo máy nóng khi sạc.', 2, 1),
(2, 'Kiểm tra pin iPhone 15', 'Khách hàng Customer (ID 7) báo máy tụt pin nhanh.', 2, 2),
(3, 'Sửa lỗi kẹt giấy máy in', 'Khách hàng Le Chi (ID 10) báo máy in HP kẹt giấy.', 2, 3),
(4, 'Kiểm tra màn hình iPad', 'Khách hàng Pham Duong (ID 11) báo màn hình sọc.', 2, 4);

INSERT INTO task_details (task_id, technical_staff_id, deadline, status) VALUES
(1, 3, '2025-10-08 17:00:00', 'in_progress'),
(2, 3, '2025-10-09 17:00:00', 'pending'),
(3, 3, '2025-10-10 17:00:00', 'pending');

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
(2, 36);

-- Technical Staff
INSERT INTO role_permission (role_id, permission_id) VALUES
(3, 2), 
(3, 3),
(3, 14),
(3, 16), 
(3, 36);

-- Customer Support Staff
INSERT INTO role_permission (role_id, permission_id) VALUES
(4, 14),
(4, 23), (4, 25), (4, 26),
(4, 35), (4, 36);

-- Storekeeper
INSERT INTO role_permission (role_id, permission_id) VALUES
(5, 12), (5, 13), (5, 14), (5, 15), 
(5, 16), (5, 17), (5, 18), 
(5, 23), (5, 24), (5, 25), (5, 26),
(5, 28),
(5, 31), (5, 32), (5, 33), (5, 34);

-- Customer
INSERT INTO role_permission (role_id, permission_id) VALUES
(6, 14), 
(6, 24), (6, 25), (6, 26),
(6, 27), (6, 30),
(6, 37);

INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (33, 12, 'IPAD-SN9383', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (34, 6, 'IPHONE-SN5497', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (35, 8, 'CANON-SN5551', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (36, 6, 'IPHONE-SN7913', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (37, 11, 'SAMSUNG-SN5897', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (38, 6, 'IPHONE-SN2125', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (39, 6, 'IPHONE-SN5377', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (40, 11, 'SAMSUNG-SN4946', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (41, 4, 'SAMSUNG-SN5830', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (42, 6, 'IPHONE-SN5094', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (43, 3, 'IPHONE-SN5631', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (44, 11, 'SAMSUNG-SN8267', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (45, 3, 'IPHONE-SN9404', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (46, 8, 'CANON-SN2265', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (47, 7, 'HP-SN7280', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (48, 9, 'LENOVO-SN1709', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (49, 1, 'DELL-SN8295', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (50, 11, 'SAMSUNG-SN8279', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (51, 3, 'IPHONE-SN2381', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (52, 14, 'USB-C-SN8594', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (53, 10, 'ASUS-SN3397', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (54, 1, 'DELL-SN9202', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (55, 14, 'USB-C-SN2893', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (56, 11, 'SAMSUNG-SN3573', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (57, 8, 'CANON-SN1392', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (58, 4, 'SAMSUNG-SN9849', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (59, 2, 'MACBOOK-SN1605', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (60, 10, 'ASUS-SN1403', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (61, 13, 'PRINTER-SN1138', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (62, 11, 'SAMSUNG-SN2686', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (63, 5, 'LAPTOP-SN6409', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (64, 11, 'SAMSUNG-SN6673', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (65, 5, 'LAPTOP-SN2746', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (66, 3, 'IPHONE-SN8571', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (67, 6, 'IPHONE-SN4508', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (68, 8, 'CANON-SN4542', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (69, 12, 'IPAD-SN4053', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (70, 8, 'CANON-SN4141', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (71, 9, 'LENOVO-SN1604', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (72, 11, 'SAMSUNG-SN2793', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (73, 4, 'SAMSUNG-SN6510', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (74, 7, 'HP-SN8223', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (75, 5, 'LAPTOP-SN2223', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (76, 9, 'LENOVO-SN1872', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (77, 3, 'IPHONE-SN6722', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (78, 2, 'MACBOOK-SN2882', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (79, 5, 'LAPTOP-SN5051', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (80, 10, 'ASUS-SN8808', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (81, 13, 'PRINTER-SN9576', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (82, 10, 'ASUS-SN7073', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (83, 7, 'HP-SN3259', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (84, 7, 'HP-SN8204', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (85, 6, 'IPHONE-SN4601', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (86, 14, 'USB-C-SN5776', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (87, 4, 'SAMSUNG-SN6600', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (88, 5, 'LAPTOP-SN2858', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (89, 9, 'LENOVO-SN8346', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (90, 8, 'CANON-SN3807', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (91, 9, 'LENOVO-SN2617', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (92, 11, 'SAMSUNG-SN5058', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (93, 5, 'LAPTOP-SN7621', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (94, 14, 'USB-C-SN2902', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (95, 9, 'LENOVO-SN3295', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (96, 8, 'CANON-SN7834', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (97, 3, 'IPHONE-SN1167', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (98, 1, 'DELL-SN6272', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (99, 1, 'DELL-SN1307', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (100, 8, 'CANON-SN3866', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (101, 4, 'SAMSUNG-SN2436', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (102, 8, 'CANON-SN3792', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (103, 11, 'SAMSUNG-SN7468', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (104, 2, 'MACBOOK-SN6062', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (105, 1, 'DELL-SN5282', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (106, 6, 'IPHONE-SN5920', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (107, 6, 'IPHONE-SN4537', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (108, 6, 'IPHONE-SN2693', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (109, 11, 'SAMSUNG-SN5586', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (110, 6, 'IPHONE-SN4445', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (111, 3, 'IPHONE-SN3847', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (112, 6, 'IPHONE-SN5297', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (113, 6, 'IPHONE-SN1292', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (114, 5, 'LAPTOP-SN3129', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (115, 8, 'CANON-SN5372', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (116, 14, 'USB-C-SN1969', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (117, 8, 'CANON-SN6808', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (118, 7, 'HP-SN9124', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (119, 7, 'HP-SN5603', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (120, 7, 'HP-SN4338', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (121, 7, 'HP-SN5831', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (122, 14, 'USB-C-SN9875', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (123, 14, 'USB-C-SN7429', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (124, 10, 'ASUS-SN1323', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (125, 7, 'HP-SN9029', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (126, 13, 'PRINTER-SN5289', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (127, 2, 'MACBOOK-SN7402', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (128, 5, 'LAPTOP-SN3100', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (129, 1, 'DELL-SN4808', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (130, 14, 'USB-C-SN7771', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (131, 14, 'USB-C-SN7438', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (132, 3, 'IPHONE-SN9126', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (133, 2, 'MACBOOK-SN4473', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (134, 2, 'MACBOOK-SN8519', 'sold', '2025-09-01 00:00:00');
INSERT INTO device_serials (id, device_id, serial_no, status, import_date) VALUES (135, 13, 'PRINTER-SN8332', 'sold', '2025-09-01 00:00:00');

-- Generated Warranty Cards
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (33, 33, 9, '2025-10-07 00:00:00', '2027-10-07 00:00:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (34, 34, 9, '2025-10-07 03:14:00', '2027-10-07 03:14:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (35, 35, 7, '2025-10-07 08:25:00', '2027-10-07 08:25:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (36, 36, 7, '2025-10-07 08:25:00', '2027-10-07 08:25:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (37, 37, 7, '2025-10-07 08:25:00', '2027-10-07 08:25:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (38, 38, 10, '2025-10-07 14:00:00', '2027-10-07 14:00:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (39, 39, 10, '2025-10-07 14:00:00', '2027-10-07 14:00:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (40, 40, 6, '2025-10-07 17:56:00', '2027-10-07 17:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (41, 41, 6, '2025-10-07 17:56:00', '2027-10-07 17:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (42, 42, 8, '2025-10-07 18:57:00', '2027-10-07 18:57:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (43, 43, 8, '2025-10-07 18:57:00', '2027-10-07 18:57:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (44, 44, 8, '2025-10-07 18:57:00', '2027-10-07 18:57:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (45, 45, 6, '2025-10-07 22:50:00', '2027-10-07 22:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (46, 46, 6, '2025-10-07 22:50:00', '2027-10-07 22:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (47, 47, 6, '2025-10-07 22:50:00', '2027-10-07 22:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (48, 48, 8, '2025-10-08 04:10:00', '2027-10-08 04:10:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (49, 49, 8, '2025-10-08 04:10:00', '2027-10-08 04:10:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (50, 50, 7, '2025-10-08 06:49:00', '2027-10-08 06:49:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (51, 51, 9, '2025-10-08 09:52:00', '2027-10-08 09:52:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (52, 52, 8, '2025-10-08 12:48:00', '2027-10-08 12:48:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (53, 53, 8, '2025-10-08 12:48:00', '2027-10-08 12:48:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (54, 54, 8, '2025-10-08 12:48:00', '2027-10-08 12:48:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (55, 55, 9, '2025-10-08 15:13:00', '2027-10-08 15:13:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (56, 56, 9, '2025-10-08 15:13:00', '2027-10-08 15:13:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (57, 57, 9, '2025-10-08 15:13:00', '2027-10-08 15:13:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (58, 58, 10, '2025-10-08 17:35:00', '2027-10-08 17:35:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (59, 59, 10, '2025-10-08 17:35:00', '2027-10-08 17:35:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (60, 60, 8, '2025-10-08 22:37:00', '2027-10-08 22:37:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (61, 61, 8, '2025-10-08 22:37:00', '2027-10-08 22:37:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (62, 62, 10, '2025-10-09 02:21:00', '2027-10-09 02:21:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (63, 63, 10, '2025-10-09 02:21:00', '2027-10-09 02:21:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (64, 64, 10, '2025-10-09 02:21:00', '2027-10-09 02:21:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (65, 65, 7, '2025-10-09 03:58:00', '2027-10-09 03:58:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (66, 66, 7, '2025-10-09 03:58:00', '2027-10-09 03:58:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (67, 67, 6, '2025-10-09 06:28:00', '2027-10-09 06:28:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (68, 68, 10, '2025-10-09 12:06:00', '2027-10-09 12:06:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (69, 69, 7, '2025-10-09 16:29:00', '2027-10-09 16:29:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (70, 70, 7, '2025-10-09 16:29:00', '2027-10-09 16:29:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (71, 71, 9, '2025-10-09 20:22:00', '2027-10-09 20:22:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (72, 72, 9, '2025-10-09 20:22:00', '2027-10-09 20:22:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (73, 73, 8, '2025-10-09 21:26:00', '2027-10-09 21:26:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (74, 74, 7, '2025-10-10 03:19:00', '2027-10-10 03:19:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (75, 75, 7, '2025-10-10 03:19:00', '2027-10-10 03:19:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (76, 76, 7, '2025-10-10 03:19:00', '2027-10-10 03:19:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (77, 77, 11, '2025-10-10 08:10:00', '2027-10-10 08:10:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (78, 78, 11, '2025-10-10 08:10:00', '2027-10-10 08:10:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (79, 79, 11, '2025-10-10 10:50:00', '2027-10-10 10:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (80, 80, 11, '2025-10-10 10:50:00', '2027-10-10 10:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (81, 81, 11, '2025-10-10 10:50:00', '2027-10-10 10:50:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (82, 82, 8, '2025-10-10 13:51:00', '2027-10-10 13:51:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (83, 83, 8, '2025-10-10 13:51:00', '2027-10-10 13:51:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (84, 84, 7, '2025-10-10 16:23:00', '2027-10-10 16:23:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (85, 85, 7, '2025-10-10 16:23:00', '2027-10-10 16:23:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (86, 86, 12, '2025-10-10 18:33:00', '2027-10-10 18:33:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (87, 87, 11, '2025-10-10 23:56:00', '2027-10-10 23:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (88, 88, 11, '2025-10-10 23:56:00', '2027-10-10 23:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (89, 89, 11, '2025-10-10 23:56:00', '2027-10-10 23:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (90, 90, 7, '2025-10-11 05:08:00', '2027-10-11 05:08:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (91, 91, 11, '2025-10-11 10:06:00', '2027-10-11 10:06:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (92, 92, 11, '2025-10-11 10:06:00', '2027-10-11 10:06:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (93, 93, 11, '2025-10-11 10:06:00', '2027-10-11 10:06:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (94, 94, 12, '2025-10-11 12:22:00', '2027-10-11 12:22:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (95, 95, 12, '2025-10-11 12:22:00', '2027-10-11 12:22:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (96, 96, 10, '2025-10-11 14:21:00', '2027-10-11 14:21:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (97, 97, 12, '2025-10-11 19:33:00', '2027-10-11 19:33:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (98, 98, 12, '2025-10-11 19:33:00', '2027-10-11 19:33:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (99, 99, 11, '2025-10-11 23:56:00', '2027-10-11 23:56:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (100, 100, 11, '2025-10-12 02:17:00', '2027-10-12 02:17:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (101, 101, 7, '2025-10-12 07:36:00', '2027-10-12 07:36:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (102, 102, 7, '2025-10-12 07:36:00', '2027-10-12 07:36:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (103, 103, 7, '2025-10-12 07:36:00', '2027-10-12 07:36:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (104, 104, 9, '2025-10-12 10:37:00', '2027-10-12 10:37:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (105, 105, 9, '2025-10-12 10:37:00', '2027-10-12 10:37:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (106, 106, 9, '2025-10-12 10:37:00', '2027-10-12 10:37:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (107, 107, 6, '2025-10-12 12:44:00', '2027-10-12 12:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (108, 108, 6, '2025-10-12 12:44:00', '2027-10-12 12:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (109, 109, 6, '2025-10-12 12:44:00', '2027-10-12 12:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (110, 110, 8, '2025-10-12 15:19:00', '2027-10-12 15:19:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (111, 111, 8, '2025-10-12 15:19:00', '2027-10-12 15:19:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (112, 112, 10, '2025-10-12 18:22:00', '2027-10-12 18:22:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (113, 113, 9, '2025-10-12 21:14:00', '2027-10-12 21:14:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (114, 114, 9, '2025-10-12 21:14:00', '2027-10-12 21:14:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (115, 115, 10, '2025-10-13 02:07:00', '2027-10-13 02:07:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (116, 116, 10, '2025-10-13 02:07:00', '2027-10-13 02:07:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (117, 117, 12, '2025-10-13 04:52:00', '2027-10-13 04:52:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (118, 118, 12, '2025-10-13 04:52:00', '2027-10-13 04:52:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (119, 119, 10, '2025-10-13 10:44:00', '2027-10-13 10:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (120, 120, 10, '2025-10-13 10:44:00', '2027-10-13 10:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (121, 121, 10, '2025-10-13 10:44:00', '2027-10-13 10:44:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (122, 122, 10, '2025-10-13 12:05:00', '2027-10-13 12:05:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (123, 123, 10, '2025-10-13 12:05:00', '2027-10-13 12:05:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (124, 124, 6, '2025-10-13 13:09:00', '2027-10-13 13:09:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (125, 125, 6, '2025-10-13 13:09:00', '2027-10-13 13:09:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (126, 126, 6, '2025-10-13 13:09:00', '2027-10-13 13:09:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (127, 127, 8, '2025-10-13 14:20:00', '2027-10-13 14:20:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (128, 128, 8, '2025-10-13 14:20:00', '2027-10-13 14:20:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (129, 129, 6, '2025-10-13 17:38:00', '2027-10-13 17:38:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (130, 130, 12, '2025-10-13 21:12:00', '2027-10-13 21:12:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (131, 131, 12, '2025-10-13 21:12:00', '2027-10-13 21:12:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (132, 132, 12, '2025-10-13 21:12:00', '2027-10-13 21:12:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (133, 133, 10, '2025-10-14 01:40:00', '2027-10-14 01:40:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (134, 134, 10, '2025-10-14 01:40:00', '2027-10-14 01:40:00');
INSERT INTO warranty_cards (id, device_serial_id, customer_id, start_at, end_at) VALUES (135, 135, 10, '2025-10-14 01:40:00', '2027-10-14 01:40:00');

-- Generated Orders
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (21, 9, 599.00, 'confirmed', '2025-10-07 00:00:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (22, 9, 20.00, 'confirmed', '2025-10-07 03:14:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (23, 7, 1069.00, 'confirmed', '2025-10-07 08:25:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (24, 10, 40.00, 'confirmed', '2025-10-07 14:00:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (25, 6, 1698.00, 'confirmed', '2025-10-07 17:56:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (26, 8, 1818.00, 'confirmed', '2025-10-07 18:57:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (27, 6, 1569.00, 'confirmed', '2025-10-07 22:50:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (28, 8, 3050.00, 'confirmed', '2025-10-08 04:10:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (29, 7, 799.00, 'confirmed', '2025-10-08 06:49:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (30, 9, 999.00, 'confirmed', '2025-10-08 09:52:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (31, 8, 3109.00, 'confirmed', '2025-10-08 12:48:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (32, 9, 1058.00, 'confirmed', '2025-10-08 15:13:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (33, 10, 3099.00, 'confirmed', '2025-10-08 17:35:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (34, 8, 1935.00, 'confirmed', '2025-10-08 22:37:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (35, 10, 1643.00, 'confirmed', '2025-10-09 02:21:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (36, 7, 1044.00, 'confirmed', '2025-10-09 03:58:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (37, 6, 20.00, 'confirmed', '2025-10-09 06:28:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (38, 10, 250.00, 'confirmed', '2025-10-09 12:06:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (39, 7, 849.00, 'confirmed', '2025-10-09 16:29:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (40, 9, 2649.00, 'confirmed', '2025-10-09 20:22:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (41, 8, 899.00, 'confirmed', '2025-10-09 21:26:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (42, 7, 2215.00, 'confirmed', '2025-10-10 03:19:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (43, 11, 3199.00, 'confirmed', '2025-10-10 08:10:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (44, 11, 1980.00, 'confirmed', '2025-10-10 10:50:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (45, 8, 2220.00, 'confirmed', '2025-10-10 13:51:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (46, 7, 340.00, 'confirmed', '2025-10-10 16:23:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (47, 12, 9.00, 'confirmed', '2025-10-10 18:33:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (48, 11, 2794.00, 'confirmed', '2025-10-10 23:56:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (49, 7, 250.00, 'confirmed', '2025-10-11 05:08:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (50, 11, 2694.00, 'confirmed', '2025-10-11 10:06:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (51, 12, 1859.00, 'confirmed', '2025-10-11 12:22:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (52, 10, 250.00, 'confirmed', '2025-10-11 14:21:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (53, 12, 2199.00, 'confirmed', '2025-10-11 19:33:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (54, 11, 1200.00, 'confirmed', '2025-10-11 23:56:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (55, 11, 250.00, 'confirmed', '2025-10-12 02:17:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (56, 7, 1948.00, 'confirmed', '2025-10-12 07:36:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (57, 9, 3420.00, 'confirmed', '2025-10-12 10:37:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (58, 6, 839.00, 'confirmed', '2025-10-12 12:44:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (59, 8, 1019.00, 'confirmed', '2025-10-12 15:19:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (60, 10, 20.00, 'confirmed', '2025-10-12 18:22:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (61, 9, 65.00, 'confirmed', '2025-10-12 21:14:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (62, 10, 259.00, 'confirmed', '2025-10-13 02:07:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (63, 12, 570.00, 'confirmed', '2025-10-13 04:52:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (64, 10, 960.00, 'confirmed', '2025-10-13 10:44:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (65, 10, 18.00, 'confirmed', '2025-10-13 12:05:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (66, 6, 2255.00, 'confirmed', '2025-10-13 13:09:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (67, 8, 2245.00, 'confirmed', '2025-10-13 14:20:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (68, 6, 1200.00, 'confirmed', '2025-10-13 17:38:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (69, 12, 1017.00, 'confirmed', '2025-10-13 21:12:00');
INSERT INTO orders (id, customer_id, total_amount, status, date) VALUES (70, 10, 4435.00, 'confirmed', '2025-10-14 01:40:00');

-- Generated Order Details
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (6, 12, 34, 1, 599.00, 0.00, 33);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (23, 8, 35, 1, 250.00, 0.00, 35);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (23, 6, 36, 1, 20.00, 0.00, 36);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (23, 11, 37, 1, 799.00, 0.00, 37);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (24, 6, 38, 1, 20.00, 0.00, 38);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (24, 6, 39, 1, 20.00, 0.00, 39);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (25, 11, 40, 1, 799.00, 0.00, 40);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (25, 4, 41, 1, 899.00, 0.00, 41);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (26, 6, 42, 1, 20.00, 0.00, 42);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (26, 3, 43, 1, 999.00, 0.00, 43);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (26, 11, 44, 1, 799.00, 0.00, 44);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (27, 3, 45, 1, 999.00, 0.00, 45);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (27, 8, 46, 1, 250.00, 0.00, 46);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (27, 7, 47, 1, 320.00, 0.00, 47);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (28, 9, 48, 1, 1850.00, 0.00, 48);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (28, 1, 49, 1, 1200.00, 0.00, 49);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (29, 11, 50, 1, 799.00, 0.00, 50);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (30, 3, 51, 1, 999.00, 0.00, 51);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (31, 14, 52, 1, 9.00, 0.00, 52);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (31, 10, 53, 1, 1900.00, 0.00, 53);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (31, 1, 54, 1, 1200.00, 0.00, 54);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (32, 14, 55, 1, 9.00, 0.00, 55);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (32, 11, 56, 1, 799.00, 0.00, 56);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (32, 8, 57, 1, 250.00, 0.00, 57);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (33, 4, 58, 1, 899.00, 0.00, 58);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (33, 2, 59, 1, 2200.00, 0.00, 59);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (34, 10, 60, 1, 1900.00, 0.00, 60);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (34, 13, 61, 1, 35.00, 0.00, 61);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (35, 11, 62, 1, 799.00, 0.00, 62);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (35, 5, 63, 1, 45.00, 0.00, 63);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (35, 11, 64, 1, 799.00, 0.00, 64);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (36, 5, 65, 1, 45.00, 0.00, 65);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (36, 3, 66, 1, 999.00, 0.00, 66);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (37, 6, 67, 1, 20.00, 0.00, 67);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (38, 8, 68, 1, 250.00, 0.00, 68);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (39, 12, 69, 1, 599.00, 0.00, 69);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (39, 8, 70, 1, 250.00, 0.00, 70);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (40, 9, 71, 1, 1850.00, 0.00, 71);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (40, 11, 72, 1, 799.00, 0.00, 72);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (41, 4, 73, 1, 899.00, 0.00, 73);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (42, 7, 74, 1, 320.00, 0.00, 74);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (42, 5, 75, 1, 45.00, 0.00, 75);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (42, 9, 76, 1, 1850.00, 0.00, 76);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (43, 3, 77, 1, 999.00, 0.00, 77);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (43, 2, 78, 1, 2200.00, 0.00, 78);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (44, 5, 79, 1, 45.00, 0.00, 79);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (44, 10, 80, 1, 1900.00, 0.00, 80);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (44, 13, 81, 1, 35.00, 0.00, 81);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (45, 10, 82, 1, 1900.00, 0.00, 82);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (45, 7, 83, 1, 320.00, 0.00, 83);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (46, 7, 84, 1, 320.00, 0.00, 84);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (46, 6, 85, 1, 20.00, 0.00, 85);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (47, 14, 86, 1, 9.00, 0.00, 86);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (48, 4, 87, 1, 899.00, 0.00, 87);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (48, 5, 88, 1, 45.00, 0.00, 88);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (48, 9, 89, 1, 1850.00, 0.00, 89);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (49, 8, 90, 1, 250.00, 0.00, 90);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (50, 9, 91, 1, 1850.00, 0.00, 91);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (50, 11, 92, 1, 799.00, 0.00, 92);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (50, 5, 93, 1, 45.00, 0.00, 93);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (51, 14, 94, 1, 9.00, 0.00, 94);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (51, 9, 95, 1, 1850.00, 0.00, 95);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (52, 8, 96, 1, 250.00, 0.00, 96);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (53, 3, 97, 1, 999.00, 0.00, 97);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (53, 1, 98, 1, 1200.00, 0.00, 98);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (54, 1, 99, 1, 1200.00, 0.00, 99);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (55, 8, 100, 1, 250.00, 0.00, 100);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (56, 4, 101, 1, 899.00, 0.00, 101);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (56, 8, 102, 1, 250.00, 0.00, 102);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (56, 11, 103, 1, 799.00, 0.00, 103);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (57, 2, 104, 1, 2200.00, 0.00, 104);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (57, 1, 105, 1, 1200.00, 0.00, 105);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (57, 6, 106, 1, 20.00, 0.00, 106);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (58, 6, 107, 1, 20.00, 0.00, 107);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (58, 6, 108, 1, 20.00, 0.00, 108);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (58, 11, 109, 1, 799.00, 0.00, 109);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (59, 6, 110, 1, 20.00, 0.00, 110);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (59, 3, 111, 1, 999.00, 0.00, 111);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (60, 6, 112, 1, 20.00, 0.00, 112);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (61, 6, 113, 1, 20.00, 0.00, 113);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (61, 5, 114, 1, 45.00, 0.00, 114);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (62, 8, 115, 1, 250.00, 0.00, 115);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (62, 14, 116, 1, 9.00, 0.00, 116);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (63, 8, 117, 1, 250.00, 0.00, 117);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (63, 7, 118, 1, 320.00, 0.00, 118);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (64, 7, 119, 1, 320.00, 0.00, 119);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (64, 7, 120, 1, 320.00, 0.00, 120);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (64, 7, 121, 1, 320.00, 0.00, 121);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (65, 14, 122, 1, 9.00, 0.00, 122);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (65, 14, 123, 1, 9.00, 0.00, 123);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (66, 10, 124, 1, 1900.00, 0.00, 124);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (66, 7, 125, 1, 320.00, 0.00, 125);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (66, 13, 126, 1, 35.00, 0.00, 126);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (67, 2, 127, 1, 2200.00, 0.00, 127);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (67, 5, 128, 1, 45.00, 0.00, 128);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (68, 1, 129, 1, 1200.00, 0.00, 129);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (69, 14, 130, 1, 9.00, 0.00, 130);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (69, 14, 131, 1, 9.00, 0.00, 131);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (69, 3, 132, 1, 999.00, 0.00, 132);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (70, 2, 133, 1, 2200.00, 0.00, 133);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (70, 2, 134, 1, 2200.00, 0.00, 134);
INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, discount, warranty_card_id) VALUES (70, 13, 135, 1, 35.00, 0.00, 135);

-- Generated Payments
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (21, NULL, 'success', '2025-10-07 00:05:00', '2025-10-07 00:05:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (22, NULL, 'success', '2025-10-07 03:19:00', '2025-10-07 03:19:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (23, NULL, 'success', '2025-10-07 08:30:00', '2025-10-07 08:30:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (24, NULL, 'success', '2025-10-07 14:05:00', '2025-10-07 14:05:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (25, NULL, 'success', '2025-10-07 18:01:00', '2025-10-07 18:01:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (26, NULL, 'success', '2025-10-07 19:02:00', '2025-10-07 19:02:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (27, NULL, 'success', '2025-10-07 22:55:00', '2025-10-07 22:55:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (28, NULL, 'success', '2025-10-08 04:15:00', '2025-10-08 04:15:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (29, NULL, 'success', '2025-10-08 06:54:00', '2025-10-08 06:54:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (30, NULL, 'success', '2025-10-08 09:57:00', '2025-10-08 09:57:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (31, NULL, 'success', '2025-10-08 12:53:00', '2025-10-08 12:53:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (32, NULL, 'success', '2025-10-08 15:18:00', '2025-10-08 15:18:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (33, NULL, 'success', '2025-10-08 17:40:00', '2025-10-08 17:40:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (34, NULL, 'success', '2025-10-08 22:42:00', '2025-10-08 22:42:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (35, NULL, 'success', '2025-10-09 02:26:00', '2025-10-09 02:26:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (36, NULL, 'success', '2025-10-09 04:03:00', '2025-10-09 04:03:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (37, NULL, 'success', '2025-10-09 06:33:00', '2025-10-09 06:33:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (38, NULL, 'success', '2025-10-09 12:11:00', '2025-10-09 12:11:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (39, NULL, 'success', '2025-10-09 16:34:00', '2025-10-09 16:34:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (40, NULL, 'success', '2025-10-09 20:27:00', '2025-10-09 20:27:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (41, NULL, 'success', '2025-10-09 21:31:00', '2025-10-09 21:31:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (42, NULL, 'success', '2025-10-10 03:24:00', '2025-10-10 03:24:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (43, NULL, 'success', '2025-10-10 08:15:00', '2025-10-10 08:15:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (44, NULL, 'success', '2025-10-10 10:55:00', '2025-10-10 10:55:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (45, NULL, 'success', '2025-10-10 13:56:00', '2025-10-10 13:56:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (46, NULL, 'success', '2025-10-10 16:28:00', '2025-10-10 16:28:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (47, NULL, 'success', '2025-10-10 18:38:00', '2025-10-10 18:38:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (48, NULL, 'success', '2025-10-11 00:01:00', '2025-10-11 00:01:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (49, NULL, 'success', '2025-10-11 05:13:00', '2025-10-11 05:13:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (50, NULL, 'success', '2025-10-11 10:11:00', '2025-10-11 10:11:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (51, NULL, 'success', '2025-10-11 12:27:00', '2025-10-11 12:27:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (52, NULL, 'success', '2025-10-11 14:26:00', '2025-10-11 14:26:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (53, NULL, 'success', '2025-10-11 19:38:00', '2025-10-11 19:38:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (54, NULL, 'success', '2025-10-12 00:01:00', '2025-10-12 00:01:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (55, NULL, 'success', '2025-10-12 02:22:00', '2025-10-12 02:22:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (56, NULL, 'success', '2025-10-12 07:41:00', '2025-10-12 07:41:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (57, NULL, 'success', '2025-10-12 10:42:00', '2025-10-12 10:42:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (58, NULL, 'success', '2025-10-12 12:49:00', '2025-10-12 12:49:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (59, NULL, 'success', '2025-10-12 15:24:00', '2025-10-12 15:24:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (60, NULL, 'success', '2025-10-12 18:27:00', '2025-10-12 18:27:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (61, NULL, 'success', '2025-10-12 21:19:00', '2025-10-12 21:19:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (62, NULL, 'success', '2025-10-13 02:12:00', '2025-10-13 02:12:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (63, NULL, 'success', '2025-10-13 04:57:00', '2025-10-13 04:57:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (64, NULL, 'success', '2025-10-13 10:49:00', '2025-10-13 10:49:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (65, NULL, 'success', '2025-10-13 12:10:00', '2025-10-13 12:10:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (66, NULL, 'success', '2025-10-13 13:14:00', '2025-10-13 13:14:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (67, NULL, 'success', '2025-10-13 14:25:00', '2025-10-13 14:25:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (68, NULL, 'success', '2025-10-13 17:43:00', '2025-10-13 17:43:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (69, NULL, 'success', '2025-10-13 21:17:00', '2025-10-13 21:17:00');
INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (70, NULL, 'success', '2025-10-14 01:45:00', '2025-10-14 01:45:00');

-- Generated Transactions
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (21, 5, 9, NULL, '2025-10-07 00:06:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (22, 5, 9, NULL, '2025-10-07 03:20:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (23, 5, 7, NULL, '2025-10-07 08:31:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (24, 5, 10, NULL, '2025-10-07 14:06:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (25, 5, 6, NULL, '2025-10-07 18:02:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (26, 5, 8, NULL, '2025-10-07 19:03:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (27, 5, 6, NULL, '2025-10-07 22:56:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (28, 5, 8, NULL, '2025-10-08 04:16:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (29, 5, 7, NULL, '2025-10-08 06:55:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (30, 5, 9, NULL, '2025-10-08 09:58:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (31, 5, 8, NULL, '2025-10-08 12:54:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (32, 5, 9, NULL, '2025-10-08 15:19:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (33, 5, 10, NULL, '2025-10-08 17:41:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (34, 5, 8, NULL, '2025-10-08 22:43:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (35, 5, 10, NULL, '2025-10-09 02:27:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (36, 5, 7, NULL, '2025-10-09 04:04:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (37, 5, 6, NULL, '2025-10-09 06:34:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (38, 5, 10, NULL, '2025-10-09 12:12:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (39, 5, 7, NULL, '2025-10-09 16:35:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (40, 5, 9, NULL, '2025-10-09 20:28:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (41, 5, 8, NULL, '2025-10-09 21:32:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (42, 5, 7, NULL, '2025-10-10 03:25:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (43, 5, 11, NULL, '2025-10-10 08:16:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (44, 5, 11, NULL, '2025-10-10 10:56:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (45, 5, 8, NULL, '2025-10-10 13:57:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (46, 5, 7, NULL, '2025-10-10 16:29:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (47, 5, 12, NULL, '2025-10-10 18:39:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (48, 5, 11, NULL, '2025-10-11 00:02:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (49, 5, 7, NULL, '2025-10-11 05:14:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (50, 5, 11, NULL, '2025-10-11 10:12:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (51, 5, 12, NULL, '2025-10-11 12:28:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (52, 5, 10, NULL, '2025-10-11 14:27:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (53, 5, 12, NULL, '2025-10-11 19:39:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (54, 5, 11, NULL, '2025-10-12 00:02:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (55, 5, 11, NULL, '2025-10-12 02:23:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (56, 5, 7, NULL, '2025-10-12 07:42:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (57, 5, 9, NULL, '2025-10-12 10:43:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (58, 5, 6, NULL, '2025-10-12 12:50:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (59, 5, 8, NULL, '2025-10-12 15:25:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (60, 5, 10, NULL, '2025-10-12 18:28:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (61, 5, 9, NULL, '2025-10-12 21:20:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (62, 5, 10, NULL, '2025-10-13 02:13:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (63, 5, 12, NULL, '2025-10-13 04:58:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (64, 5, 10, NULL, '2025-10-13 10:50:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (65, 5, 10, NULL, '2025-10-13 12:11:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (66, 5, 6, NULL, '2025-10-13 13:15:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (67, 5, 8, NULL, '2025-10-13 14:26:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (68, 5, 6, NULL, '2025-10-13 17:44:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (69, 5, 12, NULL, '2025-10-13 21:18:00', 'export', 'confirmed');
INSERT INTO transactions (id, storekeeper_id, user_id, supplier_id, date, type, status) VALUES (70, 5, 10, NULL, '2025-10-14 01:46:00', 'export', 'confirmed');

-- Generated Transaction Details
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (21, 12, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (22, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (23, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (23, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (23, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (24, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (24, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (25, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (25, 4, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (26, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (26, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (26, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (27, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (27, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (27, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (28, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (28, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (29, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (30, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (31, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (31, 10, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (31, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (32, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (32, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (32, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (33, 4, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (33, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (34, 10, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (34, 13, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (35, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (35, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (35, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (36, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (36, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (37, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (38, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (39, 12, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (39, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (40, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (40, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (41, 4, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (42, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (42, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (42, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (43, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (43, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (44, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (44, 10, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (44, 13, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (45, 10, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (45, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (46, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (46, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (47, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (48, 4, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (48, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (48, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (49, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (50, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (50, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (50, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (51, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (51, 9, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (52, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (53, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (53, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (54, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (55, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (56, 4, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (56, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (56, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (57, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (57, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (57, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (58, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (58, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (58, 11, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (59, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (59, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (60, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (61, 6, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (61, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (62, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (62, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (63, 8, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (63, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (64, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (64, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (64, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (65, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (65, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (66, 10, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (66, 7, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (66, 13, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (67, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (67, 5, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (68, 1, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (69, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (69, 14, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (69, 3, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (70, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (70, 2, 1);
INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (70, 13, 1);

INSERT INTO devices (id, category_id, name, price, unit, image_url, description) VALUES
(25, 1, 'Dell XPS 15', 1899.00, 'pcs', NULL, '15.6" OLED, Intel Core Ultra 9, NVIDIA RTX 40-series; máy trạm sáng tạo mạnh mẽ.'),
(26, 1, 'Lenovo Yoga 9i 14', 1450.00, 'pcs', NULL, '14" 2-in-1, màn hình OLED 4K, Bowers & Wilkins soundbar; thiết kế xoay gập cao cấp.'),
(27, 1, 'HP Envy x360 15', 950.00, 'pcs', NULL, '15.6" 2-in-1, AMD Ryzen 7, màn cảm ứng; laptop linh hoạt cho công việc và giải trí.'),
(28, 1, 'Acer Swift Go 14', 850.00, 'pcs', NULL, '14" OLED, Intel Core Ultra 7, siêu mỏng nhẹ; tối ưu cho di động và hiệu năng.'),
(29, 1, 'ASUS Zenbook Duo', 1999.00, 'pcs', NULL, 'Laptop 2 màn hình 14" OLED, bàn phím rời; trải nghiệm đa nhiệm đỉnh cao.'),
(30, 1, 'Samsung Galaxy Book4 Ultra', 2399.00, 'pcs', NULL, '16" Dynamic AMOLED 2X, Intel Core Ultra 9, RTX 4070; hiệu năng cao trong hệ sinh thái Samsung.'),
(31, 1, 'Lenovo Legion 5 Pro', 1599.00, 'pcs', NULL, '16" gaming, màn QHD+ 165Hz, AMD Ryzen + RTX; tản nhiệt hiệu quả, hiệu năng ổn định.'),
(32, 1, 'HP Omen 16', 1650.00, 'pcs', NULL, '16.1" gaming, Intel Core i7, RTX 4060, tản nhiệt OMEN Tempest; thiết kế hiện đại.'),
(33, 1, 'Microsoft Surface Pro 9', 1299.00, 'pcs', NULL, '13" 2-in-1, Intel Core i7, màn PixelSense 120Hz; kết hợp sức mạnh laptop và sự linh hoạt tablet.'),
(34, 1, 'Dell Inspiron 16', 799.00, 'pcs', NULL, '16" FHD+, Intel Core i5/i7, RAM DDR5; laptop văn phòng màn hình lớn, giá hợp lý.'),
(35, 1, 'Acer Predator Helios 300', 1499.00, 'pcs', NULL, '15.6" QHD 165Hz, Intel Core i7, RTX 30-series; laptop gaming tầm trung phổ biến.'),
(36, 1, 'Lenovo IdeaPad Slim 5', 750.00, 'pcs', NULL, '14" OLED, AMD Ryzen 5, thiết kế mỏng nhẹ; lựa chọn tốt cho sinh viên, văn phòng.'),
(37, 1, 'ASUS Vivobook Pro 15 OLED', 1100.00, 'pcs', NULL, '15.6" OLED, AMD Ryzen 9, NVIDIA RTX; dành cho nhà sáng tạo nội dung.'),
(38, 1, 'Framework Laptop 13', 1049.00, 'pcs', NULL, '13.5" laptop module, cho phép tự nâng cấp và sửa chữa; bền vững và tùy biến cao.'),
(39, 1, 'MSI Katana 15', 999.00, 'pcs', NULL, '15.6" 144Hz, Intel Core i7, RTX 4050; laptop gaming nhập môn với bàn phím RGB.'),


(40, 2, 'Samsung Galaxy S24 Ultra', 1299.00, 'pcs', NULL, 'Flagship 6.8", bút S Pen, khung Titan, camera 200MP; đỉnh cao nhiếp ảnh và Galaxy AI.'),
(41, 2, 'iPhone 15 Pro Max', 1399.00, 'pcs', NULL, 'Smartphone 6.7", chip A17 Pro, camera tele 5x, pin tốt nhất; lựa chọn cao cấp nhất của Apple.'),
(42, 2, 'Google Pixel 9 Pro', 999.00, 'pcs', NULL, 'Flagship Google, chip Tensor G4, hệ thống camera chuyên nghiệp với tính năng AI độc quyền.'),
(43, 2, 'Samsung Galaxy Z Flip 5', 999.00, 'pcs', NULL, 'Điện thoại gập vỏ sò, màn hình ngoài Flex Window lớn; nhỏ gọn, thời trang và linh hoạt.'),
(44, 2, 'Xiaomi 14 Ultra', 1499.00, 'pcs', NULL, 'Hệ thống camera Leica Summilux, cảm biến 1-inch, quay video 8K; smartphone chuyên chụp ảnh.'),
(45, 2, 'Sony Xperia 1 VI', 1399.00, 'pcs', NULL, 'Màn hình 4K, camera tele zoom quang học thực, các tính năng chuyên nghiệp từ máy ảnh Alpha.'),
(46, 2, 'Nothing Phone (3)', 699.00, 'pcs', NULL, 'Thiết kế trong suốt độc đáo với giao diện Glyph, trải nghiệm Android tối giản và khác biệt.'),
(47, 2, 'Motorola Razr+', 999.00, 'pcs', NULL, 'Điện thoại gập vỏ sò, màn hình ngoài lớn nhất phân khúc, thiết kế da vegan cao cấp.'),
(48, 2, 'Oppo Find X7 Ultra', 1199.00, 'pcs', NULL, 'Camera Hasselblad, hai camera tele tiềm vọng; khả năng zoom và chụp chân dung ấn tượng.'),
(49, 2, 'Vivo X100 Pro', 1150.00, 'pcs', NULL, 'Camera ZEISS APO, chip Dimensity 9300, chuyên gia chụp ảnh thiếu sáng và tele.'),
(50, 2, 'Samsung Galaxy A55', 450.00, 'pcs', NULL, 'Smartphone tầm trung, khung kim loại, màn Super AMOLED 120Hz, kháng nước IP67; cân bằng tốt.'),
(51, 2, 'iPhone SE (4th Gen)', 499.00, 'pcs', NULL, 'Thiết kế giống iPhone 14, chip A-series mạnh mẽ, nút Action; lựa chọn iPhone giá rẻ nhất.'),
(52, 2, 'Google Pixel 8a', 499.00, 'pcs', NULL, 'Trải nghiệm AI của Google với giá tầm trung, camera chụp ảnh đẹp, cập nhật phần mềm lâu dài.'),
(53, 2, 'OnePlus Nord 4', 480.00, 'pcs', NULL, 'Hiệu năng mạnh mẽ trong tầm giá, sạc nhanh SUPERVOOC, màn hình mượt mà.'),
(54, 2, 'Xiaomi Redmi Note 14 Pro', 399.00, 'pcs', NULL, 'Smartphone tầm trung với camera 200MP, sạc nhanh 120W, màn hình AMOLED 120Hz.');


UPDATE devices
SET is_featured = TRUE
WHERE id IN (1, 5, 12, 4, 6, 3, 25, 26, 14, 27, 30);

INSERT INTO carts (id, sum, user_id) VALUES (1, 2, 9); 
INSERT INTO cart_details (price, quantity, cart_id, device_id) VALUES
(2200.00, 1, 1, 2),
(20.00, 1, 1, 6);

INSERT INTO carts (id, sum, user_id) VALUES (2, 2, 10);
INSERT INTO cart_details (price, quantity, cart_id, device_id) VALUES
(1200.00, 1, 2, 1), 
(45.00, 1, 2, 5);

INSERT INTO carts (id, sum, user_id) VALUES (3, 2, 8);
INSERT INTO cart_details (price, quantity, cart_id, device_id) VALUES
(799.00, 1, 3, 11), 
(9.00, 1, 3, 14); 

INSERT INTO carts (id, sum, user_id) VALUES (4, 2, 11); 
INSERT INTO cart_details (price, quantity, cart_id, device_id) VALUES
(999.00, 1, 4, 3),
(2200.00, 1, 4, 2)