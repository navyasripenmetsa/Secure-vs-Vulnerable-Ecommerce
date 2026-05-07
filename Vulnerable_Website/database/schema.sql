CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    password VARCHAR(100),
    role VARCHAR(50) DEFAULT 'user',
    email VARCHAR(100),
    last_processed DATETIME DEFAULT NULL
);

INSERT INTO users (id, username, password, role, email, last_processed) VALUES
(2, 'user1', 'pass123', 'user', 'user1@test.com', NULL),
(7, 'thanu', 'thanu123', 'user', 'thanu@gmail.com', NULL),
(8, 'navyasri', 'hehehe', 'admin', 'devanddoodlestyle@gmail.com', NULL),
(9, 'hemachouhan', 'hema12345', 'user', 'hema@gmail.com', NULL),
(10, 'eshikha', '1231053', 'user', 'eshikha@gmail.com', NULL),
(11, 'admin', 'admin123', 'admin', 'admin@test.com', NULL);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price FLOAT,
    category VARCHAR(50)
);

INSERT INTO products (id, name, description, price, category) VALUES
(1, 'Headphones', 'Noise cancelling headphones', 5000, 'Electronics'),
(2, 'Smart Watch', 'Fitness tracking smartwatch', 7000, 'Electronics'),
(3, 'Backpack', 'Waterproof travel backpack', 1500, 'Fashion'),
(4, 'T-Shirt', 'Cotton casual t-shirt', 800, 'Fashion'),
(5, 'Jeans', 'Slim fit denim jeans', 1800, 'Fashion'),
(6, 'Coffee Maker', 'Automatic coffee machine', 4000, 'Home Appliances'),
(7, 'Blender', 'Kitchen blender with 3 jars', 2500, 'Home Appliances'),
(8, 'Book - Python', 'Learn Python programming', 600, 'Books'),
(9, 'Book - DBMS', 'Database management systems', 750, 'Books'),
(10, 'Office Chair', 'Ergonomic office chair', 9000, 'Furniture'),
(11, 'Table Lamp', 'LED study lamp', 1200, 'Furniture'),
(12, 'Keyboard', 'Mechanical gaming keyboard', 3500, 'Electronics'),
(13, 'Mouse', 'Wireless optical mouse', 1200, 'Electronics');

CREATE TABLE attack_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    user_id INT NULL,
    endpoint VARCHAR(100),
    attack_type VARCHAR(50),
    payload TEXT,
    status VARCHAR(50)
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    total_price FLOAT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (user_id, product_id, quantity, total_price, created_at) VALUES
(8, 1, 1, 5000, '2026-04-12 17:44:21'),
(8, 3, 2, 3000, '2026-04-12 17:44:21'),
(8, 8, 1, 600, '2026-04-12 17:44:21'),
(9, 2, 1, 7000, '2026-04-12 17:44:21'),
(9, 4, 2, 1600, '2026-04-12 17:44:21'),
(9, 6, 1, 4000, '2026-04-12 17:44:21'),
(9, 12, 1, 3500, '2026-04-12 17:44:21'),
(10, 5, 1, 1800, '2026-04-12 17:44:21'),
(10, 11, 1, 1200, '2026-04-12 17:44:21'),
(10, 13, 1, 1200, '2026-04-12 17:44:21');

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO reviews (user_id, product_id, comment, created_at) VALUES
(8, 1, 'Worth buying for this price :)', '2026-04-08 01:41:54'),
(8, 1, 'Worth buying for this price', '2026-04-08 01:46:59'),
(8, 1, 'Quality is poor', '2026-04-08 11:45:46'),
(7, 1, '', '2026-04-08 11:57:22'),
(9, 11, 'Battery lasts only for few mins :(', '2026-04-08 12:19:52'),
(8, 1, ':(', '2026-04-08 22:00:28'),
(8, 9, 'This book is a good start for beginners', '2026-04-08 22:36:56'),
(8, 4, 'Color is Fading away fast', '2026-04-08 23:19:36'),
(10, 1, 'These headphones deliver an excellent listening...', '2026-04-12 16:34:56');
