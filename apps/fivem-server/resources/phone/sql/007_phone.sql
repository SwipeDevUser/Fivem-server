-- Phone System Schema

CREATE TABLE phone_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_text VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);

CREATE TABLE phone_calls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    caller_id INT NOT NULL,
    receiver_id INT,
    duration INT DEFAULT 0,
    call_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP NULL,
    FOREIGN KEY (caller_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);

CREATE TABLE phone_contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    contact_name VARCHAR(50),
    contact_number INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES users(id),
    UNIQUE KEY unique_contact (player_id, contact_number)
);

CREATE INDEX idx_messages_sender ON phone_messages(sender_id);
CREATE INDEX idx_messages_receiver ON phone_messages(receiver_id);
CREATE INDEX idx_calls_caller ON phone_calls(caller_id);
CREATE INDEX idx_contacts_player ON phone_contacts(player_id);
