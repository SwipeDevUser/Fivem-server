-- Police Fines Schema

CREATE TABLE fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    amount INT NOT NULL,
    reason VARCHAR(255),
    officer_id INT,
    issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid BOOLEAN DEFAULT FALSE,
    paid_date TIMESTAMP NULL
);

CREATE INDEX idx_fines_player ON fines(player_id);
CREATE INDEX idx_fines_paid ON fines(paid);
