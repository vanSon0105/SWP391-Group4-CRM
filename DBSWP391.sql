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
  phone VARCHAR(20) unique,
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
    is_cancelled TINYINT(1) DEFAULT 0,
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
  cancelled_by_warranty TINYINT(1) DEFAULT 0,
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


INSERT INTO roles (role_name, description) VALUES
('Admin', 'Quản trị hệ thống'),
('Technical Manager', 'Quản lý bộ phận kỹ thuật và các nhiệm vụ liên quan'),
('Technical Staff', 'Thực hiện các công việc kỹ thuật'),
('Customer Support Staff', 'Xử lý yêu cầu hỗ trợ của khách hàng'),
('Storekeeper', 'Quản lý kho và hàng tồn'),
('Customer', 'Người dùng cuối đặt thiết bị');


INSERT INTO `users` VALUES 
(1,'admin01','$2a$12$VtfCsGI2a1szKsECzdKMvuSB1qNm9cj3p27bOwRbkh7cfGr/pwXZ.','admin@example.com',NULL,'System Admin','0901234567','other',NULL,1,'active',1,0,'2025-11-10 19:11:45','2025-11-12 11:16:40'),
(2,'manager01','$2a$12$BM7JVY7D0r21mzY1s4hM9OP7Lstu991E7K38ZHfy4TuZGepBHrh1G','manager@example.com',NULL,'Van Son','0902345678','other',NULL,2,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:56:17'),
(3,'techstaff01','$2a$12$UiSPhKWnuo/ZXSYZBDetWeoimiKI.Pun.2/A95jXSp60OSbUVLJ8e','staff01@example.com',NULL,'Duc Nguyen','0903456789','other',NULL,3,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:21:41'),
(4,'techstaff02','$2a$12$Ap8Qjy/Xe4.52NYXwXAFX.vx8aFOaBfSEjDxfpD0IhahEoyo11CQ.','staff02@example.com',NULL,'Duc Nguye','0903456786','other',NULL,3,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:21:49'),
(5,'techstaff03','$2a$12$dC1TT3giLVoetO4tat5Y6OMOnrmjtM/WFsB16JblhPds7FxJMoBrC','staff03@example.com',NULL,'Duc Nguy','0903456787','other',NULL,3,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:54:55'),
(6,'techstaff04','$2a$12$6qXyxasPHFJ9bgiyBSHsd.LHAvSJKu03fTNrQ5qu..0A5WnI6CJa.','staff04@example.com',NULL,'Duc Ngu','0903456788','other',NULL,3,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:55:23'),
(7,'spstaff01','$2a$12$pPL6YWGicOyM1dplPd.IsuSq/do3GHFp8Uc9CoYrzINBqPmeW28jW','spstaff01@example.com',NULL,'Xuan Bac','0904567890','other',NULL,4,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:21:16'),
(8,'storekeeper01','$2a$12$CXARlFxOA7k6kGotYsPpf./AlU3WxZf9kx79m060b.eMBjZa238Se','storekeeper@example.com',NULL,'Hai Dang','0905678901','other',NULL,5,'active',1,0,'2025-11-10 19:11:45','2025-11-12 05:13:43'),
(9,'customer01','$2a$12$bpQYKe3icKVM6AJw3M.iA.fGXr.AbOb.Dmc0ZuhRLl72CaYkBTa8O','customer01@example.com',NULL,'Hieu Pham','0906789012','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-12 18:16:51'),
(10,'customer02','$2a$12$CQw4YUO3m4aTAXw.YwTcEu38z9/bnXxmcCNDVorLWBe4P0aPyyTKG','customer02@example.com',NULL,'Customer','0907890123','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:57:19'),
(11,'customer03','$2a$12$1O3iiQUBTirexaraQ0EI/.tvhpu2hZR1Vyw5S9oquxHcZq/KnGsjS','customer03@example.com',NULL,'Nguyen An','0908000003','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:57:48'),
(12,'customer04','$2a$12$G8n3a0YMwq9/kSNwW3vLjeSUz8j9YyAcIu8c8oAJYh.dYHCSh8bYy','customer04@example.com',NULL,'Tran Binh','0908000004','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:58:12'),
(13,'customer05','$2a$12$eNCqEKqgrGkQD5Pm/7yAt.I1YJZxxAJcvypYAhQLpxBpICe2OBXHO','customer05@example.com',NULL,'Le Chi','0908000005','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 19:58:43'),
(14,'customer06','$2a$12$D9wiBHN3V8/SjXNGL9MB3OZl0nXboOUBMSQT8ijpmgIfvmbxDZ8W2','customer06@example.com',NULL,'Pham Duong','0908000006','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:07:18'),
(15,'customer07','$2a$12$icmy/A/Ys2R58i4igtBkJeRb6JLA57eklFjbt5Iig4kLSRpsXe9pm','customer07@example.com',NULL,'Hoai Giang','0908000007','other',NULL,6,'active',1,0,'2025-11-10 19:11:45','2025-11-10 20:07:45');



INSERT INTO categories (category_name) VALUES
('Laptop'),
('Smartphone'),
('Printer'),
('Spare Parts');

INSERT INTO `devices` VALUES (1,1,'Dell XPS 13',27990000,'pcs','1762822073646-214-1.webp','13\" ultrabook, Intel Core, 16GB RAM, 512GB SSD, ~1.2kg; phù hợp di động/doanh nhân.','2025-11-10 19:11:45',1,12,'active'),
(2,1,'MacBook Pro 14',54990000,'pcs','1762822114121-photo-1678096201160-16780962014221791750585-1678097088540-16780970891802110218923.webp','14\" laptop Apple Silicon, màn Liquid Retina XDR, thời lượng pin dài; máy trạm sáng tạo.','2025-11-10 19:11:45',1,24,'active'),
(3,2,'iPhone 15',24990000,'pcs','1762822137039-iphone-15-pro-max-blue-thumbnew-600x600.jpg','Smartphone 6.1\", chip A16, camera cải thiện, sạc USB-C; flagship cân bằng hiệu năng.','2025-11-10 19:11:45',1,12,'active'),
(4,2,'Samsung Galaxy S24',21990000,'pcs','1762822163655-Samsung-galaxy-s24-fe-5g-8gb-128gb-cty-xtmobile.webp','Flagship 6.2\", màn AMOLED 120Hz, Exynos/Snapdragon, AI features; chụp ảnh mạnh.','2025-11-10 19:11:45',1,24,'active'),
(5,4,'Laptop Charger 65W',490000,'pcs','1762822195133-715Px5qeqtL._AC_SL1500_.jpg','Sạc laptop 65W (DC/USB-C tuỳ mẫu), bảo vệ quá dòng/quá nhiệt; phù hợp đa số ultrabook.','2025-11-10 19:11:45',0,6,'active'),
(6,4,'iPhone Case',290000,'pcs','1762822225056-clear-case-iphone-16-879062.webp','Ốp bảo vệ silicon/TPU, chống trầy xước, bám tay tốt; viền nhô bảo vệ camera/màn hình.','2025-11-10 19:11:45',0,6,'active'),
(7,3,'HP LaserJet Pro M404',8490000,'pcs','1762822255564-hp-laserjet-pro-m404dn-1.jpg','Máy in laser đơn sắc A4, ~38 ppm, kết nối USB/Ethernet; in văn phòng bền bỉ.','2025-11-10 19:11:45',0,24,'active'),
(8,3,'Canon Pixma G3020',5990000,'pcs','1762822285300-45446_pri_can_g3020_a.jpg','Máy in phun bình mực liên tục (G-Series), in màu, Wi-Fi, copy/scan; chi phí trang thấp.','2025-11-10 19:11:45',0,12,'active'),
(9,1,'Lenovo ThinkPad X1 Carbon',42990000,'pcs','1762822311149-picture-31627382329_1710656113-3.jpg','14\" business ultralight, khung carbon, bàn phím ThinkPad, nhiều cổng; bền đạt chuẩn MIL-STD.','2025-11-10 19:11:45',1,24,'active'),
(10,1,'ASUS ROG Zephyrus G14',45990000,'pcs','1762822334253-50871_rog_zephyrus_g14_23ecdf926b6a46fa887a95de8b1d409f_grande_5361640af98943f59d5b1af718d6a65a_grande.png','14\" gaming mỏng nhẹ, Ryzen + GeForce RTX, màn 120–165Hz; cân bằng game/đồ hoạ.','2025-11-10 19:11:45',1,24,'active'),
(11,2,'Samsung Galaxy Tab S9',19990000,'pcs','1762822363889-TabS9FE-FE_KV_MO_720x720.webp','Tablet AMOLED ~11\", S Pen kèm, DeX, IP68; ghi chú và giải trí tốt.','2025-11-10 19:11:45',0,12,'active'),
(12,2,'iPad Air (5th Gen)',14990000,'pcs','1762822384127-7_18_54_1_1_2_1_1.webp','Tablet 10.9\" chip M1, Apple Pencil/Keyboard, màn Liquid Retina; tối ưu học tập/sáng tạo.','2025-11-10 19:11:45',1,24,'active'),
(13,4,'Printer Toner Cartridge',890000,'pcs','1762822422353-71diAnbDe9L.jpg','Hộp mực laser tương thích M404, năng suất ~3.000 trang; dễ thay thế, mực đều.','2025-11-10 19:11:45',0,6,'active'),
(14,4,'USB-C Cable 1m',199000,'pcs','1762822458249-4ec0d3ed2c0b5d07_CAB003BT0M-BLK_BoostCharge_USB-C_to_USB-C_Gallery_Shot_03_WEB.jpg','Cáp USB-C to C 1m, sạc đến 60W/3A, truyền dữ liệu; lõi bền, đầu nối chắc.','2025-11-10 19:11:45',0,6,'active'),
(15,1,'Dell XPS 15',48990000,'pcs','1762822483555-xp7590nt-cnb-00055lf110-gy.psd--1--ovi9-04-www.laptopvip.vn-1619517716.webp','15.6\" OLED, Intel Core Ultra 9, NVIDIA RTX 40-series; máy trạm sáng tạo mạnh mẽ.','2025-11-10 19:11:45',1,24,'active'),
(16,1,'Lenovo Yoga 9i 14',38990000,'pcs','1762822504468-877102225314.jpg','14\" 2-in-1, màn hình OLED 4K, Bowers & Wilkins soundbar; thiết kế xoay gập cao cấp.','2025-11-10 19:11:45',0,24,'active'),
(17,1,'HP Envy x360 15',24990000,'pcs','1762822524242-hp-envy-13-x360-2021-4-1641697404.jpg','15.6\" 2-in-1, AMD Ryzen 7, màn cảm ứng; laptop linh hoạt cho công việc và giải trí.','2025-11-10 19:11:45',0,12,'active'),
(18,1,'Acer Swift Go 14',21990000,'pcs','1762822547305-2023_12_14_638381737194405257_Laptop Acer Swift Go SFG14-41-R19Z-4.webp','14\" OLED, Intel Core Ultra 7, siêu mỏng nhẹ; tối ưu cho di động và hiệu năng.','2025-11-10 19:11:45',0,12,'active'),
(19,1,'ASUS Zenbook Duo',51990000,'pcs','1762822568270-71xZUkl5dyL._AC_UF894,1000_QL80_.jpg','Laptop 2 màn hình 14\" OLED, bàn phím rời; trải nghiệm đa nhiệm đỉnh cao.','2025-11-10 19:11:45',0,24,'active'),
(20,1,'Samsung Galaxy Book4 Ultra',59990000,'pcs','1762822589962-danh-gia-samsung-galaxy-book-4-ultra-chiec-laptop-cao-cap-gan-nhu-hoan-hao-cover-0-0-0-0-1721893177.jpg','16\" Dynamic AMOLED 2X, Intel Core Ultra 9, RTX 4070; hiệu năng cao trong hệ sinh thái Samsung.','2025-11-10 19:11:45',0,24,'active'),
(21,1,'Lenovo Legion 5 Pro',39990000,'pcs','1762822610028-lenovo-legion-5-pro-16iax10-ultra-9-83f3002gvn-1-638862961797834850-750x500.jpg','16\" gaming, màn QHD+ 165Hz, AMD Ryzen + RTX; tản nhiệt hiệu quả, hiệu năng ổn định.','2025-11-10 19:11:45',0,24,'active'),
(22,1,'HP Omen 16',41990000,'pcs','1762822634470-hp-omen-16-2021-1640753935.jpg','16.1\" gaming, Intel Core i7, RTX 4060, tản nhiệt OMEN Tempest; thiết kế hiện đại.','2025-11-10 19:11:45',0,24,'active'),
(23,1,'Microsoft Surface Pro 9',32990000,'pcs','1762822662882-moi-100-microsoft-surface-pro-9-4252-5.jpg','13\" 2-in-1, Intel Core i7, màn PixelSense 120Hz; kết hợp sức mạnh laptop và sự linh hoạt tablet.','2025-11-10 19:11:45',1,12,'active'),
(24,1,'Dell Inspiron 16',19990000,'pcs','1762822681326-dell-inspiron-16-5640-core-7-n6i7512w1-1-750x500.jpg','16\" FHD+, Intel Core i5/i7, RAM DDR5; laptop văn phòng màn hình lớn, giá hợp lý.','2025-11-10 19:11:45',0,12,'active'),
(25,1,'Acer Predator Helios 300',37990000,'pcs','1762822703001-acer-predator-helios-300-2022-7-2lgxh8p.webp','15.6\" QHD 165Hz, Intel Core i7, RTX 30-series; laptop gaming tầm trung phổ biến.','2025-11-10 19:11:45',0,24,'active'),
(26,1,'Lenovo IdeaPad Slim 5',18990000,'pcs','1762822730414-laptop-lenovo-ideapad-slim-5-14q8x9-05.webp','14\" OLED, AMD Ryzen 5, thiết kế mỏng nhẹ; lựa chọn tốt cho sinh viên, văn phòng.','2025-11-10 19:11:45',0,12,'active'),
(27,1,'ASUS Vivobook Pro 15 OLED',28990000,'pcs','1762822753337-asus-vivobook-pro-15-oled-k6502z-i7-ma036w-241122-102229-600x600.jpg','15.6\" OLED, AMD Ryzen 9, NVIDIA RTX; dành cho nhà sáng tạo nội dung.','2025-11-10 19:11:45',0,12,'active'),
(28,1,'Framework Laptop 13',29990000,'pcs','1762822788005-IMG_2067.jpeg','13.5\" laptop module, cho phép tự nâng cấp và sửa chữa; bền vững và tùy biến cao.','2025-11-10 19:11:45',0,12,'active'),
(29,1,'MSI Katana 15',25990000,'pcs','1762822807020-msi-katana-15-b13vfk-i7-676vn-1-750x500.jpg','15.6\" 144Hz, Intel Core i7, RTX 4050; laptop gaming nhập môn với bàn phím RGB.','2025-11-10 19:11:45',0,12,'active'),
(30,2,'Samsung Galaxy S24 Ultra',33990000,'pcs','1762822827795-samsung-galaxy-s24-ultra-xam-1-750x500.jpg','Flagship 6.8\", bút S Pen, khung Titan, camera 200MP; đỉnh cao nhiếp ảnh và Galaxy AI.','2025-11-10 19:11:45',0,24,'active'),
(31,2,'iPhone 15 Pro Max',35990000,'pcs','1762822845890-iphone-15-pro-max_2__5_2_1_1.webp','Smartphone 6.7\", chip A17 Pro, camera tele 5x, pin tốt nhất; lựa chọn cao cấp nhất của Apple.','2025-11-10 19:11:45',1,12,'active'),
(32,2,'Google Pixel 9 Pro',28990000,'pcs','1762822861017-dien-thoai-google-pixel-9-pro_1_.png','Flagship Google, chip Tensor G4, hệ thống camera chuyên nghiệp với tính năng AI độc quyền.','2025-11-10 19:11:45',1,12,'active'),
(33,2,'Samsung Galaxy Z Flip 5',25990000,'pcs','1762822877263-samsung-galaxy-z-flip5-5g.png','Điện thoại gập vỏ sò, màn hình ngoài Flex Window lớn; nhỏ gọn, thời trang và linh hoạt.','2025-11-10 19:11:45',0,12,'active'),
(34,2,'Xiaomi 14 Ultra',32990000,'pcs','1762822894345-xiaomi-14-ultra_3.webp','Hệ thống camera Leica Summilux, cảm biến 1-inch, quay video 8K; smartphone chuyên chụp ảnh.','2025-11-10 19:11:45',0,24,'active'),
(35,2,'Sony Xperia 1 VI',34990000,'pcs','1762822910072-10_1_.webp','Màn hình 4K, camera tele zoom quang học thực, các tính năng chuyên nghiệp từ máy ảnh Alpha.','2025-11-10 19:11:45',0,12,'active'),
(36,2,'Nothing Phone (3)',16990000,'pcs','1762822930487-Nothing-Phone-3-2.jpg','Thiết kế trong suốt độc đáo với giao diện Glyph, trải nghiệm Android tối giản và khác biệt.','2025-11-10 19:11:45',0,12,'active'),
(37,2,'Motorola Razr+',24990000,'pcs','1762822947381-motorola-razr-2019-1-600x600.jpg','Điện thoại gập vỏ sò, màn hình ngoài lớn nhất phân khúc, thiết kế da vegan cao cấp.','2025-11-10 19:11:45',0,12,'active'),
(38,2,'Oppo Find X7 Ultra',30990000,'pcs','1762822969605-1-1280x630.jpg','Camera Hasselblad, hai camera tele tiềm vọng; khả năng zoom và chụp chân dung ấn tượng.','2025-11-10 19:11:45',0,12,'active'),
(39,2,'Vivo X100 Pro',29990000,'pcs','1762822991117-dien-thoai-vivo-x100-pro_1__2.png','Camera ZEISS APO, chip Dimensity 9300, chuyên gia chụp ảnh thiếu sáng và tele.','2025-11-10 19:11:45',0,12,'active'),
(40,2,'Samsung Galaxy A55',9990000,'pcs','1762823009640-samsung-galaxy-a55.png','Smartphone tầm trung, khung kim loại, màn Super AMOLED 120Hz, kháng nước IP67; cân bằng tốt.','2025-11-10 19:11:45',0,12,'active'),
(41,2,'iPhone SE (4th Gen)',12990000,'pcs','1762823027376-iphone-se-2025-vn-a.jpg','Thiết kế giống iPhone 14, chip A-series mạnh mẽ, nút Action; lựa chọn iPhone giá rẻ nhất.','2025-11-10 19:11:45',0,12,'active'),
(42,2,'Google Pixel 8a',13990000,'pcs','1762823044514-pixel_8a_trang_baf742a0404c493882668329e2a39f90_master.jpg','Trải nghiệm AI của Google với giá tầm trung, camera chụp ảnh đẹp, cập nhật phần mềm lâu dài.','2025-11-10 19:11:45',0,12,'active'),
(43,2,'OnePlus Nord 4',11990000,'pcs','1762823063858-oneplus-nord-4.jpg','Hiệu năng mạnh mẽ trong tầm giá, sạc nhanh SUPERVOOC, màn hình mượt mà.','2025-11-10 19:11:45',0,12,'active'),
(44,2,'Xiaomi Redmi Note 14 Pro',8990000,'pcs','1762823079669-xiaomi-redmi-note-14-pro-tim.jpg.webp','Smartphone tầm trung với camera 200MP, sạc nhanh 120W, màn hình AMOLED 120Hz.','2025-11-10 19:11:45',0,12,'active');


INSERT INTO suppliers (name, phone, email, address) VALUES
('LaptopCenter', '0903333444', 'contact@laptopcenter.vn', '789, Cầu Giấy, Hà Nội'),
('DigitalZone', '0904444555', 'sales@digitalzone.vn', '12, Lê Lợi, Đà Nẵng'),
('VietMobile', '0905555666', 'info@vietmobile.vn', '99, Trần Hưng Đạo, TP. Hồ Chí Minh'),
('ProPrinter', '0906666777', 'support@proprinter.vn', '25, Nguyễn Văn Linh, Hải Phòng'),
('StarTech', '0907777888', 'sales@startech.vn', '68, Lý Thường Kiệt, Cần Thơ'),
('FutureDevice', '0908888999', 'contact@futuredevice.vn', '15, Phạm Văn Đồng, Hà Nội');



INSERT INTO supplier_details (supplier_id, device_id, date, price) VALUES
(1, 1, '2025-10-01 09:00:00', 23791500),
(1, 2, '2025-10-01 09:00:00', 46741500),
(3, 3, '2025-10-01 09:00:00', 21241500),
(3, 4, '2025-10-01 09:00:00', 18691500),
(5, 5, '2025-10-01 09:00:00', 416500),
(5, 6, '2025-10-01 09:00:00', 246500),
(4, 7, '2025-10-01 09:00:00', 7216500),
(4, 8, '2025-10-01 09:00:00', 5091500),
(1, 9, '2025-10-01 09:00:00', 36541500),
(1, 10, '2025-10-01 09:00:00', 39091500),
(3, 11, '2025-10-01 09:00:00', 16991500),
(3, 12, '2025-10-01 09:00:00', 12741500),
(5, 13, '2025-10-01 09:00:00', 756500),
(5, 14, '2025-10-01 09:00:00', 169150),
(1, 15, '2025-10-01 09:00:00', 41641500),
(1, 16, '2025-10-01 09:00:00', 33141500),
(1, 17, '2025-10-01 09:00:00', 21241500),
(1, 18, '2025-10-01 09:00:00', 18691500),
(1, 19, '2025-10-01 09:00:00', 44191500),
(1, 20, '2025-10-01 09:00:00', 50991500),
(1, 21, '2025-10-01 09:00:00', 33991500),
(1, 22, '2025-10-01 09:00:00', 35691500),
(1, 23, '2025-10-01 09:00:00', 28041500),
(1, 24, '2025-10-01 09:00:00', 16991500),
(1, 25, '2025-10-01 09:00:00', 32291500),
(1, 26, '2025-10-01 09:00:00', 16141500),
(1, 27, '2025-10-01 09:00:00', 24641500),
(1, 28, '2025-10-01 09:00:00', 25491500),
(1, 29, '2025-10-01 09:00:00', 22091500),
(3, 30, '2025-10-01 09:00:00', 28891500),
(3, 31, '2025-10-01 09:00:00', 30591500),
(3, 32, '2025-10-01 09:00:00', 24641500),
(3, 33, '2025-10-01 09:00:00', 22091500),
(3, 34, '2025-10-01 09:00:00', 28041500),
(3, 35, '2025-10-01 09:00:00', 29741500),
(3, 36, '2025-10-01 09:00:00', 14441500),
(3, 37, '2025-10-01 09:00:00', 21241500),
(3, 38, '2025-10-01 09:00:00', 26341500),
(3, 39, '2025-10-01 09:00:00', 25491500),
(3, 40, '2025-10-01 09:00:00', 8491500),
(3, 41, '2025-10-01 09:00:00', 11041500),
(3, 42, '2025-10-01 09:00:00', 11891500),
(3, 43, '2025-10-01 09:00:00', 10191500),
(3, 44, '2025-10-01 09:00:00', 7641500);


INSERT INTO permissions (id, permission_name) VALUES
(1, 'Quản Lí Tài Khoản'), (2, 'Quản Lí Thiết Bị'), (3, 'Quản Lí Nhà Cung Cấp'), (4, 'Quản Lí Danh Mục'), (5, 'Quản Lí Thanh Toán'), (6, 'Quản Lí Đặt Hàng'),
(7, 'Quản Lí Vấn Đề'), (8, 'Quản Lí Nhiệm Vụ'), (9, 'Quản Lí Giỏ Hàng'), (10, 'Quản Lí Hồ Sơ'), (11, 'Quản Lí Nhập/Xuất'), (12, 'Quản Lí Giao Dịch'), (13, 'Trang Nhân Viên Hỗ Trợ'),
(14, 'Trang Nhân Viên Kỹ Thuật'), (15, 'Trang Quản Lí Kỹ Thuật'), (16, 'Quản Lí Seri'), (17, 'Gửi Vấn Đề'), (18, 'Quản Lí Quyền'), (19, 'Trang Admin'), (20, 'Quản Lí Giá'), (21, 'Xem Seri'),
(22, 'Quản Lí Giá Thiết Bị'), (23, 'Xem Thiết Bị'), (24, 'Quản Lí Bảo Hành');

INSERT INTO role_permission (role_id, permission_id) VALUES (1, 1), (1, 2), (1, 3), (1, 4),
(1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 16), (1, 17), (1, 18), (1, 19), (1, 21), (1, 23), (1, 24);

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