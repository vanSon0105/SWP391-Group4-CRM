DROP DATABASE IF EXISTS SWP391;
CREATE DATABASE IF NOT EXISTS SWP391;
USE SWP391;

CREATE TABLE roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  role_name varchar(50) UNIQUE NOT NULL,
  description text
);

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(255),
  email VARCHAR(100) UNIQUE,
  image_url VARCHAR(255),
  full_name VARCHAR(100),
  phone VARCHAR(20),
  gender ENUM('male', 'female', 'other') DEFAULT 'other',
  birthday DATE,
  role_id INT,
  status ENUM('active', 'inactive') DEFAULT 'active',
  is_available boolean DEFAULT true,
  username_changed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login_at TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL
);

CREATE TABLE devices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(14,0) NOT NULL,
  unit varchar(50),
  image_url varchar(255),
  description text,
  created_at timestamp default current_timestamp,
  is_featured BOOLEAN DEFAULT FALSE,
  warrantyMonth int,
  status ENUM('active', 'discontinued') DEFAULT 'active',
  foreign key (category_id) references categories(id)
);

CREATE TABLE device_serials(
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL,
  serial_no VARCHAR(100) UNIQUE,
  stock_status ENUM('in_stock', 'sold', 'in_repair', 'out_stock') DEFAULT 'in_stock',
  status ENUM('active', 'discontinued') default 'active',
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
  total_amount DECIMAL(14,0) NOT NULL,
  discount DECIMAL(14,0) DEFAULT 0,
  status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
  date timestamp default current_timestamp,
  foreign key (customer_id) references users(id)
);

CREATE TABLE warranty_cards(
	id INT PRIMARY KEY AUTO_INCREMENT,
    device_serial_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    start_at TIMESTAMP,
    end_at TIMESTAMP,
    foreign key (device_serial_id) references device_serials(id),
    foreign key (customer_id) references users(id)
);

CREATE TABLE order_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  device_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(14,0) NOT NULL,
  foreign key (order_id) references orders(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE order_detail_serials (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_detail_id INT NOT NULL,
  device_serial_id INT NOT NULL UNIQUE,
  foreign key (order_detail_id) references order_details(id),
  foreign key (device_serial_id) references device_serials(id)
);

CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT UNIQUE NOT NULL,
  amount DECIMAL(14,0) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  delivery_time VARCHAR(50),
  technical_note TEXT,
  status ENUM('pending','success','failed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  paid_at TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id)
);


CREATE TABLE customer_issues (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  issue_code VARCHAR(50) UNIQUE,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  issue_type ENUM('warranty','repair') DEFAULT 'warranty',
  warranty_card_id INT,
  support_staff_id INT,
  feedback TEXT,
  support_status ENUM('new','in_progress','awaiting_customer','submitted','manager_review','manager_approved','manager_rejected','task_created','tech_in_progress', 'customer_cancelled', 'completed', 'create_payment', 'waiting_payment', 'waiting_confirm', 'resolved') DEFAULT 'new',
  created_at TIMESTAMP default current_timestamp,
  foreign key (customer_id) references users(id),
  foreign key (warranty_card_id) references warranty_cards(id),
  foreign key (support_staff_id) references users(id)
);

CREATE TABLE tasks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  manager_id INT NOT NULL,
  customer_issue_id INT not null,
  is_cancelled boolean default false,
  foreign key (manager_id) references users(id),
  foreign key (customer_issue_id) references customer_issues(id)
);


CREATE TABLE task_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  task_id INT NOT NULL,
  technical_staff_id INT NOT NULL,
  assigned_at timestamp default current_timestamp,
  deadline timestamp,
  note TEXT,
  status ENUM('pending','in_progress','completed','cancelled') DEFAULT 'pending',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (task_id) references tasks(id),
  foreign key (technical_staff_id) references users(id)
);

CREATE OR REPLACE VIEW task_with_status AS
SELECT
  t.id,
  t.title,
  t.description,
  t.manager_id,
  t.customer_issue_id,
  t.is_cancelled,
  CASE
    WHEN t.is_cancelled = TRUE THEN 'cancelled'
    WHEN COUNT(td.id) = 0 THEN 'pending'
    WHEN SUM(CASE WHEN td.status = 'cancelled' THEN 1 ELSE 0 END) = COUNT(td.id) THEN 'cancelled'
    WHEN SUM(CASE WHEN td.status = 'completed' THEN 1 ELSE 0 END) = COUNT(td.id) THEN 'completed'
    WHEN SUM(CASE WHEN td.status = 'in_progress' THEN 1 ELSE 0 END) > 0 THEN 'in_progress'
    WHEN SUM(CASE WHEN td.status = 'pending' THEN 1 ELSE 0 END) = COUNT(td.id) THEN 'pending'
    ELSE 'in_progress'
  END AS status
FROM tasks t
LEFT JOIN task_details td ON t.id = td.task_id
GROUP BY t.id, t.title, t.description, t.manager_id, t.customer_issue_id, t.is_cancelled;


CREATE TABLE customer_issue_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  issue_id INT NOT NULL,
  support_staff_id INT NOT NULL,
  customer_full_name VARCHAR(100),
  contact_email VARCHAR(100),
  contact_phone VARCHAR(20),
  device_serial VARCHAR(100),
  summary TEXT,
  forward_to_manager BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (issue_id) references customer_issues(id),
  foreign key (support_staff_id) references users(id)
);

CREATE TABLE suppliers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  address VARCHAR(255),
  status tinyint default 1
);

CREATE TABLE issue_payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  issue_id INT UNIQUE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  note VARCHAR(500),
  shipping_full_name VARCHAR(100),
  shipping_phone VARCHAR(20),
  shipping_address VARCHAR(255),
  shipping_note VARCHAR(500),
  status ENUM('awaiting_support','awaiting_customer','awaiting_admin','paid','closed') DEFAULT 'awaiting_support',
  created_by INT NOT NULL,
  approved_by INT,
  confirmed_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  paid_at TIMESTAMP NULL,
  FOREIGN KEY (issue_id) REFERENCES customer_issues(id),
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (approved_by) REFERENCES users(id),
  FOREIGN KEY (confirmed_by) REFERENCES users(id)
);

CREATE TABLE supplier_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_id INT NOT NULL,
  device_id INT NOT NULL,
  date timestamp default current_timestamp,
  price DECIMAL(14,0) NOT NULL,
  foreign key (supplier_id) references suppliers(id),
  foreign key (device_id) references devices(id)
);

CREATE TABLE transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  storekeeper_id INT NOT NULL,
  user_id INT,
  supplier_id INT,
  note text,
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

CREATE TABLE carts(
  id INT PRIMARY KEY AUTO_INCREMENT,
  sum DECIMAL(14,0) default 0,
  user_id INT NOT NULL,
  foreign key (user_id) references users(id)
);

CREATE TABLE cart_details(
  id INT PRIMARY KEY AUTO_INCREMENT,
  price DECIMAL(14,0) NOT NULL,
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

INSERT INTO permissions (id, permission_name) VALUES
(1, 'Quản Lí Tài Khoản'), (2, 'Quản Lí Thiết Bị'), (3, 'Quản Lí Nhà Cung Cấp'), (4, 'Quản Lí Danh Mục'), (5, 'Quản Lí Thanh Toán'), (6, 'Quản Lí Đặt Hàng'),
(7, 'Quản Lí Vấn Đề'), (8, 'Quản Lí Nhiệm Vụ'), (9, 'Quản Lí Giỏ Hàng'), (10, 'Quản Lí Hồ Sơ'), (11, 'Quản Lí Nhập/Xuất'), (12, 'Quản Lí Giao Dịch'), (13, 'Trang Nhân Viên Hỗ Trợ'),
(14, 'Trang Nhân Viên Kỹ Thuật'), (15, 'Trang Quản Lí Kỹ Thuật'), (16, 'Quản Lí Seri'), (17, 'Gửi Vấn Đề'), (18, 'Quản Lí Quyền'), (19, 'Trang Admin'), (20, 'Quản Lí Giá'), (21, 'Xem Seri'),
(22, 'Quản Lí Giá Thiết Bị'), (23, 'Xem Thiết Bị');

INSERT INTO role_permission (role_id, permission_id) VALUES (1, 1), (1, 2), (1, 3), (1, 4),
(1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 16), (1, 17), (1, 18), (1, 19), (1, 21), (1, 23);

-- Manager 
INSERT INTO role_permission (role_id, permission_id) VALUES (2, 7), (2, 8), (2, 15), (2, 10);
-- Tech Staff
INSERT INTO role_permission (role_id, permission_id) VALUES (3, 14), (3, 10);
-- Support Staff
INSERT INTO role_permission (role_id, permission_id) VALUES (4, 13), (4, 10);
-- Storekeeper
INSERT INTO role_permission (role_id, permission_id) VALUES (5, 11), (5, 12), (5, 3), (5, 16), (5, 10), (5, 20), (5, 21), (5, 22), (5, 23);
-- Customer
INSERT INTO role_permission (role_id, permission_id) VALUES (6, 9), (6, 17), (6, 10);


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
('techstaff02', '123456', 'staff02@example.com', NULL, 'Duc Nguye', '0903456786', 3, 'active'),
('techstaff03', '123456', 'staff03@example.com', NULL, 'Duc Nguy', '0903456787', 3, 'active'),
('techstaff04', '123456', 'staff04@example.com', NULL, 'Duc Ngu', '0903456788', 3, 'active'),
('spstaff01', '123456', 'spstaff01@example.com', NULL, 'Xuan Bac', '0904567890', 4, 'active'),
('storekeeper01', '123456', 'storekeeper@example.com', NULL, 'Hai Dang', '0905678901', 5, 'active'),
('customer01', '123456', 'customer01@example.com', NULL, 'Hieu Pham', '0906789012', 6, 'active'),
('customer02', '123456', 'customer02@example.com', NULL, 'Customer', '0907890123', 6, 'active'),
('customer03', '123456', 'customer03@example.com', NULL, 'Nguyen An',  '0908000003', 6, 'active'),
('customer04', '123456', 'customer04@example.com', NULL, 'Tran Binh',  '0908000004', 6, 'active'),
('customer05', '123456', 'customer05@example.com', NULL, 'Le Chi',      '0908000005', 6, 'active'),
('customer06', '123456', 'customer06@example.com', NULL, 'Pham Duong', '0908000006', 6, 'active'),
('customer07', '123456', 'customer07@example.com', NULL, 'Hoai Giang', '0908000007', 6, 'active');

INSERT INTO categories (category_name) VALUES
('Laptop'),
('Smartphone'),
('Printer'),
('Spare Parts');

INSERT INTO devices (category_id, name, price, unit, image_url, description, warrantyMonth) VALUES
(1, 'Dell XPS 13', 27990000, 'pcs', NULL, '13" ultrabook, Intel Core, 16GB RAM, 512GB SSD, ~1.2kg; phù hợp di động/doanh nhân.', 12),
(1, 'MacBook Pro 14', 54990000, 'pcs', NULL, '14" laptop Apple Silicon, màn Liquid Retina XDR, thời lượng pin dài; máy trạm sáng tạo.', 24),
(2, 'iPhone 15', 24990000, 'pcs', NULL, 'Smartphone 6.1", chip A16, camera cải thiện, sạc USB-C; flagship cân bằng hiệu năng.', 12),
(2, 'Samsung Galaxy S24', 21990000, 'pcs', NULL, 'Flagship 6.2", màn AMOLED 120Hz, Exynos/Snapdragon, AI features; chụp ảnh mạnh.', 24),
(4, 'Laptop Charger 65W', 490000, 'pcs', NULL, 'Sạc laptop 65W (DC/USB-C tuỳ mẫu), bảo vệ quá dòng/quá nhiệt; phù hợp đa số ultrabook.', 6),
(4, 'iPhone Case', 290000, 'pcs', NULL, 'Ốp bảo vệ silicon/TPU, chống trầy xước, bám tay tốt; viền nhô bảo vệ camera/màn hình.', 6),
(3, 'HP LaserJet Pro M404', 8490000, 'pcs', NULL, 'Máy in laser đơn sắc A4, ~38 ppm, kết nối USB/Ethernet; in văn phòng bền bỉ.', 24),
(3, 'Canon Pixma G3020', 5990000, 'pcs', NULL, 'Máy in phun bình mực liên tục (G-Series), in màu, Wi-Fi, copy/scan; chi phí trang thấp.', 12),
(1, 'Lenovo ThinkPad X1 Carbon', 42990000, 'pcs', NULL, '14" business ultralight, khung carbon, bàn phím ThinkPad, nhiều cổng; bền đạt chuẩn MIL-STD.', 24),
(1, 'ASUS ROG Zephyrus G14', 45990000, 'pcs', NULL, '14" gaming mỏng nhẹ, Ryzen + GeForce RTX, màn 120–165Hz; cân bằng game/đồ hoạ.', 24),
(2, 'Samsung Galaxy Tab S9', 19990000, 'pcs', NULL, 'Tablet AMOLED ~11", S Pen kèm, DeX, IP68; ghi chú và giải trí tốt.', 12),
(2, 'iPad Air (5th Gen)', 14990000, 'pcs', NULL, 'Tablet 10.9" chip M1, Apple Pencil/Keyboard, màn Liquid Retina; tối ưu học tập/sáng tạo.', 24),
(4, 'Printer Toner Cartridge', 890000, 'pcs', NULL, 'Hộp mực laser tương thích M404, năng suất ~3.000 trang; dễ thay thế, mực đều.', 6),
(4, 'USB-C Cable 1m', 199000, 'pcs', NULL, 'Cáp USB-C to C 1m, sạc đến 60W/3A, truyền dữ liệu; lõi bền, đầu nối chắc.', 6),
(1, 'Dell XPS 15', 48990000, 'pcs', NULL, '15.6" OLED, Intel Core Ultra 9, NVIDIA RTX 40-series; máy trạm sáng tạo mạnh mẽ.', 24),
(1, 'Lenovo Yoga 9i 14', 38990000, 'pcs', NULL, '14" 2-in-1, màn hình OLED 4K, Bowers & Wilkins soundbar; thiết kế xoay gập cao cấp.', 24),
(1, 'HP Envy x360 15', 24990000, 'pcs', NULL, '15.6" 2-in-1, AMD Ryzen 7, màn cảm ứng; laptop linh hoạt cho công việc và giải trí.', 12),
(1, 'Acer Swift Go 14', 21990000, 'pcs', NULL, '14" OLED, Intel Core Ultra 7, siêu mỏng nhẹ; tối ưu cho di động và hiệu năng.', 12),
(1, 'ASUS Zenbook Duo', 51990000, 'pcs', NULL, 'Laptop 2 màn hình 14" OLED, bàn phím rời; trải nghiệm đa nhiệm đỉnh cao.', 24),
(1, 'Samsung Galaxy Book4 Ultra', 59990000, 'pcs', NULL, '16" Dynamic AMOLED 2X, Intel Core Ultra 9, RTX 4070; hiệu năng cao trong hệ sinh thái Samsung.', 24),
(1, 'Lenovo Legion 5 Pro', 39990000, 'pcs', NULL, '16" gaming, màn QHD+ 165Hz, AMD Ryzen + RTX; tản nhiệt hiệu quả, hiệu năng ổn định.', 24),
(1, 'HP Omen 16', 41990000, 'pcs', NULL, '16.1" gaming, Intel Core i7, RTX 4060, tản nhiệt OMEN Tempest; thiết kế hiện đại.', 24),
(1, 'Microsoft Surface Pro 9', 32990000, 'pcs', NULL, '13" 2-in-1, Intel Core i7, màn PixelSense 120Hz; kết hợp sức mạnh laptop và sự linh hoạt tablet.', 12),
(1, 'Dell Inspiron 16', 19990000, 'pcs', NULL, '16" FHD+, Intel Core i5/i7, RAM DDR5; laptop văn phòng màn hình lớn, giá hợp lý.', 12),
(1, 'Acer Predator Helios 300', 37990000, 'pcs', NULL, '15.6" QHD 165Hz, Intel Core i7, RTX 30-series; laptop gaming tầm trung phổ biến.', 24),
(1, 'Lenovo IdeaPad Slim 5', 18990000, 'pcs', NULL, '14" OLED, AMD Ryzen 5, thiết kế mỏng nhẹ; lựa chọn tốt cho sinh viên, văn phòng.', 12),
(1, 'ASUS Vivobook Pro 15 OLED', 28990000, 'pcs', NULL, '15.6" OLED, AMD Ryzen 9, NVIDIA RTX; dành cho nhà sáng tạo nội dung.', 12),
(1, 'Framework Laptop 13', 29990000, 'pcs', NULL, '13.5" laptop module, cho phép tự nâng cấp và sửa chữa; bền vững và tùy biến cao.', 12),
(1, 'MSI Katana 15', 25990000, 'pcs', NULL, '15.6" 144Hz, Intel Core i7, RTX 4050; laptop gaming nhập môn với bàn phím RGB.', 12),
(2, 'Samsung Galaxy S24 Ultra', 33990000, 'pcs', NULL, 'Flagship 6.8", bút S Pen, khung Titan, camera 200MP; đỉnh cao nhiếp ảnh và Galaxy AI.', 24),
(2, 'iPhone 15 Pro Max', 35990000, 'pcs', NULL, 'Smartphone 6.7", chip A17 Pro, camera tele 5x, pin tốt nhất; lựa chọn cao cấp nhất của Apple.', 12),
(2, 'Google Pixel 9 Pro', 28990000, 'pcs', NULL, 'Flagship Google, chip Tensor G4, hệ thống camera chuyên nghiệp với tính năng AI độc quyền.', 12),
(2, 'Samsung Galaxy Z Flip 5', 25990000, 'pcs', NULL, 'Điện thoại gập vỏ sò, màn hình ngoài Flex Window lớn; nhỏ gọn, thời trang và linh hoạt.', 12),
(2, 'Xiaomi 14 Ultra', 32990000, 'pcs', NULL, 'Hệ thống camera Leica Summilux, cảm biến 1-inch, quay video 8K; smartphone chuyên chụp ảnh.', 24),
(2, 'Sony Xperia 1 VI', 34990000, 'pcs', NULL, 'Màn hình 4K, camera tele zoom quang học thực, các tính năng chuyên nghiệp từ máy ảnh Alpha.', 12),
(2, 'Nothing Phone (3)', 16990000, 'pcs', NULL, 'Thiết kế trong suốt độc đáo với giao diện Glyph, trải nghiệm Android tối giản và khác biệt.', 12),
(2, 'Motorola Razr+', 24990000, 'pcs', NULL, 'Điện thoại gập vỏ sò, màn hình ngoài lớn nhất phân khúc, thiết kế da vegan cao cấp.', 12),
(2, 'Oppo Find X7 Ultra', 30990000, 'pcs', NULL, 'Camera Hasselblad, hai camera tele tiềm vọng; khả năng zoom và chụp chân dung ấn tượng.', 12),
(2, 'Vivo X100 Pro', 29990000, 'pcs', NULL, 'Camera ZEISS APO, chip Dimensity 9300, chuyên gia chụp ảnh thiếu sáng và tele.', 12),
(2, 'Samsung Galaxy A55', 9990000, 'pcs', NULL, 'Smartphone tầm trung, khung kim loại, màn Super AMOLED 120Hz, kháng nước IP67; cân bằng tốt.', 12),
(2, 'iPhone SE (4th Gen)', 12990000, 'pcs', NULL, 'Thiết kế giống iPhone 14, chip A-series mạnh mẽ, nút Action; lựa chọn iPhone giá rẻ nhất.', 12),
(2, 'Google Pixel 8a', 13990000, 'pcs', NULL, 'Trải nghiệm AI của Google với giá tầm trung, camera chụp ảnh đẹp, cập nhật phần mềm lâu dài.', 12),
(2, 'OnePlus Nord 4', 11990000, 'pcs', NULL, 'Hiệu năng mạnh mẽ trong tầm giá, sạc nhanh SUPERVOOC, màn hình mượt mà.', 12),
(2, 'Xiaomi Redmi Note 14 Pro', 8990000, 'pcs', NULL, 'Smartphone tầm trung với camera 200MP, sạc nhanh 120W, màn hình AMOLED 120Hz.', 12);

INSERT INTO device_serials (id, device_id, serial_no, stock_status, import_date) VALUES
(1, 3, 'IP15-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(2, 2, 'MBP14-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(3, 4, 'S24-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(4, 2, 'MBP14-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(5, 6, 'CASE-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(6, 1, 'XPS13-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(7, 5, 'CHARGER-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(8, 7, 'HP404-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(9, 9, 'TPX1-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(10, 12, 'IPAD-AIR-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(11, 3, 'IP15-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(12, 11, 'TABS9-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(13, 14, 'USBC-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(14, 10, 'ROG-G14-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(15, 14, 'USBC-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(16, 13, 'TONER-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(17, 13, 'TONER-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(18, 7, 'HP404-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(19, 3, 'IP15-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(20, 2, 'MBP14-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(21, 1, 'XPS13-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(22, 6, 'CASE-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(23, 8, 'CANON-G3020-SN0001', 'in_stock', '2025-09-01 00:00:00'),
(24, 7, 'HP404-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(25, 11, 'TABS9-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(26, 14, 'USBC-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(27, 9, 'TPX1-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(28, 3, 'IP15-SN0004', 'in_stock', '2025-09-01 00:00:00'),
(29, 5, 'CHARGER-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(30, 4, 'S24-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(31, 12, 'IPAD-AIR-SN0002', 'in_stock', '2025-09-01 00:00:00'),
(32, 6, 'CASE-SN0003', 'in_stock', '2025-09-01 00:00:00'),
(33, 12, 'IPAD-SN9383', 'in_stock', '2025-09-01 00:00:00'),
(34, 6, 'IPHONE-SN5497', 'in_stock', '2025-09-01 00:00:00'),
(35, 8, 'CANON-SN5551', 'in_stock', '2025-09-01 00:00:00'),
(36, 6, 'IPHONE-SN7913', 'in_stock', '2025-09-01 00:00:00'),
(37, 11, 'SAMSUNG-SN5897', 'in_stock', '2025-09-01 00:00:00'),
(38, 6, 'IPHONE-SN2125', 'in_stock', '2025-09-01 00:00:00'),
(39, 6, 'IPHONE-SN5377', 'in_stock', '2025-09-01 00:00:00'),
(40, 11, 'SAMSUNG-SN4946', 'in_stock', '2025-09-01 00:00:00'),
(41, 4, 'SAMSUNG-SN5830', 'in_stock', '2025-09-01 00:00:00'),
(42, 6, 'IPHONE-SN5094', 'in_stock', '2025-09-01 00:00:00'),
(43, 3, 'IPHONE-SN5631', 'in_stock', '2025-09-01 00:00:00'),
(44, 11, 'SAMSUNG-SN8267', 'in_stock', '2025-09-01 00:00:00'),
(45, 3, 'IPHONE-SN9404', 'in_stock', '2025-09-01 00:00:00'),
(46, 8, 'CANON-SN2265', 'in_stock', '2025-09-01 00:00:00'),
(47, 7, 'HP-SN7280', 'in_stock', '2025-09-01 00:00:00'),
(48, 9, 'LENOVO-SN1709', 'in_stock', '2025-09-01 00:00:00'),
(49, 1, 'DELL-SN8295', 'in_stock', '2025-09-01 00:00:00'),
(50, 11, 'SAMSUNG-SN8279', 'in_stock', '2025-09-01 00:00:00'),
(51, 3, 'IPHONE-SN2381', 'in_stock', '2025-09-01 00:00:00'),
(52, 14, 'USB-C-SN8594', 'in_stock', '2025-09-01 00:00:00'),
(53, 10, 'ASUS-SN3397', 'in_stock', '2025-09-01 00:00:00'),
(54, 1, 'DELL-SN9202', 'in_stock', '2025-09-01 00:00:00'),
(55, 14, 'USB-C-SN2893', 'in_stock', '2025-09-01 00:00:00'),
(56, 11, 'SAMSUNG-SN3573', 'in_stock', '2025-09-01 00:00:00'),
(57, 8, 'CANON-SN1392', 'in_stock', '2025-09-01 00:00:00'),
(58, 4, 'SAMSUNG-SN9849', 'in_stock', '2025-09-01 00:00:00'),
(59, 2, 'MACBOOK-SN1605', 'in_stock', '2025-09-01 00:00:00'),
(60, 10, 'ASUS-SN1403', 'in_stock', '2025-09-01 00:00:00'),
(61, 13, 'PRINTER-SN1138', 'in_stock', '2025-09-01 00:00:00'),
(62, 11, 'SAMSUNG-SN2686', 'in_stock', '2025-09-01 00:00:00'),
(63, 5, 'LAPTOP-SN6409', 'in_stock', '2025-09-01 00:00:00'),
(64, 11, 'SAMSUNG-SN6673', 'in_stock', '2025-09-01 00:00:00'),
(65, 5, 'LAPTOP-SN2746', 'in_stock', '2025-09-01 00:00:00'),
(66, 3, 'IPHONE-SN8571', 'in_stock', '2025-09-01 00:00:00'),
(67, 6, 'IPHONE-SN4508', 'in_stock', '2025-09-01 00:00:00'),
(68, 8, 'CANON-SN4542', 'in_stock', '2025-09-01 00:00:00'),
(69, 12, 'IPAD-SN4053', 'in_stock', '2025-09-01 00:00:00'),
(70, 8, 'CANON-SN4141', 'in_stock', '2025-09-01 00:00:00'),
(71, 9, 'LENOVO-SN1604', 'in_stock', '2025-09-01 00:00:00'),
(72, 11, 'SAMSUNG-SN2793', 'in_stock', '2025-09-01 00:00:00'),
(73, 4, 'SAMSUNG-SN6510', 'in_stock', '2025-09-01 00:00:00'),
(74, 7, 'HP-SN8223', 'in_stock', '2025-09-01 00:00:00'),
(75, 5, 'LAPTOP-SN2223', 'in_stock', '2025-09-01 00:00:00'),
(76, 9, 'LENOVO-SN1872', 'in_stock', '2025-09-01 00:00:00'),
(77, 3, 'IPHONE-SN6722', 'in_stock', '2025-09-01 00:00:00'),
(78, 2, 'MACBOOK-SN2882', 'in_stock', '2025-09-01 00:00:00'),
(79, 5, 'LAPTOP-SN5051', 'in_stock', '2025-09-01 00:00:00'),
(80, 10, 'ASUS-SN8808', 'in_stock', '2025-09-01 00:00:00'),
(81, 13, 'PRINTER-SN9576', 'in_stock', '2025-09-01 00:00:00'),
(82, 10, 'ASUS-SN7073', 'in_stock', '2025-09-01 00:00:00'),
(83, 7, 'HP-SN3259', 'in_stock', '2025-09-01 00:00:00'),
(84, 7, 'HP-SN8204', 'in_stock', '2025-09-01 00:00:00'),
(85, 6, 'IPHONE-SN4601', 'in_stock', '2025-09-01 00:00:00'),
(86, 14, 'USB-C-SN5776', 'in_stock', '2025-09-01 00:00:00'),
(87, 4, 'SAMSUNG-SN6600', 'in_stock', '2025-09-01 00:00:00'),
(88, 5, 'LAPTOP-SN2858', 'in_stock', '2025-09-01 00:00:00'),
(89, 9, 'LENOVO-SN8346', 'in_stock', '2025-09-01 00:00:00'),
(90, 8, 'CANON-SN3807', 'in_stock', '2025-09-01 00:00:00'),
(91, 9, 'LENOVO-SN2617', 'in_stock', '2025-09-01 00:00:00'),
(92, 11, 'SAMSUNG-SN5058', 'in_stock', '2025-09-01 00:00:00'),
(93, 5, 'LAPTOP-SN7621', 'in_stock', '2025-09-01 00:00:00'),
(94, 14, 'USB-C-SN2902', 'in_stock', '2025-09-01 00:00:00'),
(95, 9, 'LENOVO-SN3295', 'in_stock', '2025-09-01 00:00:00'),
(96, 8, 'CANON-SN7834', 'in_stock', '2025-09-01 00:00:00'),
(97, 3, 'IPHONE-SN1167', 'in_stock', '2025-09-01 00:00:00'),
(98, 1, 'DELL-SN6272', 'in_stock', '2025-09-01 00:00:00'),
(99, 1, 'DELL-SN1307', 'in_stock', '2025-09-01 00:00:00'),
(100, 8, 'CANON-SN3866', 'in_stock', '2025-09-01 00:00:00'),
(101, 4, 'SAMSUNG-SN2436', 'in_stock', '2025-09-01 00:00:00'),
(102, 8, 'CANON-SN3792', 'in_stock', '2025-09-01 00:00:00'),
(103, 11, 'SAMSUNG-SN7468', 'in_stock', '2025-09-01 00:00:00'),
(104, 2, 'MACBOOK-SN6062', 'in_stock', '2025-09-01 00:00:00'),
(105, 1, 'DELL-SN5282', 'in_stock', '2025-09-01 00:00:00'),
(106, 6, 'IPHONE-SN5920', 'in_stock', '2025-09-01 00:00:00'),
(107, 6, 'IPHONE-SN4537', 'in_stock', '2025-09-01 00:00:00'),
(108, 6, 'IPHONE-SN2693', 'in_stock', '2025-09-01 00:00:00'),
(109, 11, 'SAMSUNG-SN5586', 'in_stock', '2025-09-01 00:00:00'),
(110, 6, 'IPHONE-SN4445', 'in_stock', '2025-09-01 00:00:00'),
(111, 3, 'IPHONE-SN3847', 'in_stock', '2025-09-01 00:00:00'),
(112, 6, 'IPHONE-SN5297', 'in_stock', '2025-09-01 00:00:00'),
(113, 6, 'IPHONE-SN1292', 'in_stock', '2025-09-01 00:00:00'),
(114, 5, 'LAPTOP-SN3129', 'in_stock', '2025-09-01 00:00:00'),
(115, 8, 'CANON-SN5372', 'in_stock', '2025-09-01 00:00:00'),
(116, 14, 'USB-C-SN1969', 'in_stock', '2025-09-01 00:00:00'),
(117, 8, 'CANON-SN6808', 'in_stock', '2025-09-01 00:00:00'),
(118, 7, 'HP-SN9124', 'in_stock', '2025-09-01 00:00:00'),
(119, 7, 'HP-SN5603', 'in_stock', '2025-09-01 00:00:00'),
(120, 7, 'HP-SN4338', 'in_stock', '2025-09-01 00:00:00'),
(121, 7, 'HP-SN5831', 'in_stock', '2025-09-01 00:00:00'),
(122, 14, 'USB-C-SN9875', 'in_stock', '2025-09-01 00:00:00'),
(123, 14, 'USB-C-SN7429', 'in_stock', '2025-09-01 00:00:00'),
(124, 10, 'ASUS-SN1323', 'in_stock', '2025-09-01 00:00:00'),
(125, 7, 'HP-SN9029', 'in_stock', '2025-09-01 00:00:00'),
(126, 13, 'PRINTER-SN5289', 'in_stock', '2025-09-01 00:00:00'),
(127, 2, 'MACBOOK-SN7402', 'in_stock', '2025-09-01 00:00:00'),
(128, 5, 'LAPTOP-SN3100', 'in_stock', '2025-09-01 00:00:00'),
(129, 1, 'DELL-SN4808', 'in_stock', '2025-09-01 00:00:00'),
(130, 14, 'USB-C-SN7771', 'in_stock', '2025-09-01 00:00:00'),
(131, 14, 'USB-C-SN7438', 'in_stock', '2025-09-01 00:00:00'),
(132, 3, 'IPHONE-SN9126', 'in_stock', '2025-09-01 00:00:00'),
(133, 2, 'MACBOOK-SN4473', 'in_stock', '2025-09-01 00:00:00'),
(134, 2, 'MACBOOK-SN8519', 'in_stock', '2025-09-01 00:00:00'),
(135, 4, 'PRINTER-SN83324', 'in_stock', '2025-09-01 00:00:00'),
(136, 4, 'PRINTER-SN83325', 'in_stock', '2025-09-01 00:00:00'),
(137, 4, 'PRINTER-SN83326', 'in_stock', '2025-09-01 00:00:00'),
(138, 4, 'PRINTER-SN83327', 'in_stock', '2025-09-01 00:00:00'),
(139, 4, 'PRINTER-SN83328', 'in_stock', '2025-09-01 00:00:00');


INSERT INTO suppliers (name, phone, email, address) VALUES
('TechSupplier', '0901111222', 'sales@techsupplier.com', '123, Thach Hoa, Thach That, Ha Noi'),
('MobileWorld', '0902222333', 'contact@mobileworld.com', '456, Thach Hoa, Thach That, Ha Noi');


INSERT INTO supplier_details (supplier_id, device_id, price) VALUES
(1, 7, 7900000),
(1, 9, 41000000),
(1, 13, 750000),
(2, 8, 5500000),
(2, 10, 44000000),
(2, 11, 18500000),
(2, 12, 13900000),
(2, 14, 150000);

-- INSERT INTO permissions (id, permission_name) VALUES
-- (1, 'CREATE_TASK'), (2, 'VIEW_TASK_LIST'), (3, 'UPDATE_TASK'), (4, 'DELETE_TASK'), (5, 'ASSIGN_TASK'),
-- (6, 'UNASSIGN_TASK'), (7, 'CREATE_ACCOUNT'), (8, 'VIEW_ACCOUNT'), (9, 'UPDATE_ACCOUNT'), (10, 'ACTIVE_ACCOUNT'),
-- (11, 'DEACTIVE_ACCOUNT'), (12, 'CATEGORY_MANAGEMENT'), (13, 'DEVICE_MANAGEMENT'), (14, 'DEVICE_OVERVIEW'),
-- (15, 'PRICING_MANAGEMENT'), (16, 'CREATE_IMPORT_EXPORT_ORDER'), (17, 'QUANTITY_CHECK'), (18, 'IMPORT_EXPORT_REPORTS'),
-- (19, 'CRUD_SUPPLIER'), (20, 'DEVICE_SUPPLY_MANAGEMENT'), (21, 'SUPPLIER_INFORMATION_MANAGEMENT'),
-- (22, 'SUPPLIER_INFO_INTEGRATION'), (23, 'STAFF_LIST'), (25, 'ORDER_TRACKING'), (28, 'PAYMENT_REPORTS'),
-- (26, 'ORDER_REPORTS'), (27, 'CREATE_TRANSACTION'), (29, 'PAYMENT_CONFIRMATION'),
-- (30, 'PAYMENT_REQUEST_CREATION'), (31, 'ADMIN_PAGE'), (32, 'CUSTOMER_ORDER_REPORT'),
-- (33, 'SALE_REPORTS'), (34, 'INVENTORY_REPORTS'), (35, 'CUSTOMER_ISSUES_RESPONDING'), (36, 'CUSTOMER_ISSUES_MANAGEMENT'),
-- (37, 'CUSTOMER_ISSUES'), (38, 'SUPPORT_DASH'), (39, 'TECH_STAFF_DASH'), (40, 'TECH_MANAGER_DASH'), (41, 'STOREKEEPER_DASH'), 
-- (42, 'PROCESS_TASK'), (43, 'DEVICE_MANAGEMENT_NODELETE'), (44, 'TRANSACTION_MANAGEMENT'), (45, 'PRICE_UPDATE'), (46, 'ORDER_HISTORY_MANAGEMENT');






