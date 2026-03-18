-- Housing System Schema

CREATE TABLE houses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    house_id INT UNIQUE NOT NULL,
    owner INT,
    purchased_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner) REFERENCES users(id)
);

CREATE TABLE house_storage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    house_id INT NOT NULL,
    item_name VARCHAR(50) NOT NULL,
    quantity INT DEFAULT 0,
    UNIQUE KEY unique_house_item (house_id, item_name),
    FOREIGN KEY (house_id) REFERENCES houses(house_id)
);

CREATE TABLE house_tax (
    id INT AUTO_INCREMENT PRIMARY KEY,
    house_id INT NOT NULL,
    owner_id INT NOT NULL,
    amount INT NOT NULL,
    due_date TIMESTAMP,
    paid BOOLEAN DEFAULT FALSE,
    paid_date TIMESTAMP NULL,
    FOREIGN KEY (house_id) REFERENCES houses(house_id),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE INDEX idx_house_owner ON houses(owner);
CREATE INDEX idx_storage_house ON house_storage(house_id);
CREATE INDEX idx_tax_owner ON house_tax(owner_id);
