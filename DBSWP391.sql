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
(24, 7, 'HP404-SN0003', 'in_stock', '2025-09-01 00:00:00'), -- Order cancelled
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