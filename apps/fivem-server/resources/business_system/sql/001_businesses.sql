-- Business Ownership System Schema

CREATE TABLE businesses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    owner_id INT NOT NULL,
    type VARCHAR(50) DEFAULT 'General',
    balance INT DEFAULT 0,
    established_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive', 'bankrupt') DEFAULT 'active',
    FOREIGN KEY (owner_id) REFERENCES users(id),
    INDEX idx_owner (owner_id),
    INDEX idx_status (status)
);

CREATE TABLE business_employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    player_id INT NOT NULL,
    role VARCHAR(50) DEFAULT 'Employee',
    salary INT DEFAULT 0,
    hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id),
    FOREIGN KEY (player_id) REFERENCES users(id),
    UNIQUE KEY unique_business_player (business_id, player_id),
    INDEX idx_business (business_id),
    INDEX idx_player (player_id)
);

CREATE TABLE business_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    type ENUM('deposit', 'withdrawal', 'salary') DEFAULT 'deposit',
    amount INT NOT NULL,
    description VARCHAR(255),
    made_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id),
    FOREIGN KEY (made_by) REFERENCES users(id),
    INDEX idx_business (business_id),
    INDEX idx_date (created_at)
);

CREATE TABLE business_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    player_id INT NOT NULL,
    action VARCHAR(100),
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id),
    FOREIGN KEY (player_id) REFERENCES users(id),
    INDEX idx_business (business_id),
    INDEX idx_date (created_at)
);
