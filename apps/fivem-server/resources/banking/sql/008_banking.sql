-- Banking System Schema

CREATE TABLE bank_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT UNIQUE NOT NULL,
    balance INT DEFAULT 0,
    account_type VARCHAR(50) DEFAULT 'checking',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES users(id)
);

CREATE TABLE bank_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    sender_id INT,
    receiver_id INT,
    amount INT NOT NULL,
    fee INT DEFAULT 0,
    type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES users(id),
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);

CREATE INDEX idx_bank_player ON bank_accounts(player_id);
CREATE INDEX idx_transactions_player ON bank_transactions(player_id);
CREATE INDEX idx_transactions_sender ON bank_transactions(sender_id);
CREATE INDEX idx_transactions_receiver ON bank_transactions(receiver_id);
CREATE INDEX idx_transactions_date ON bank_transactions(created_at);
