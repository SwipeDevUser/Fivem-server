-- Health System Schema

CREATE TABLE player_injuries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    injury_type VARCHAR(50) NOT NULL,
    severity INT,
    treated BOOLEAN DEFAULT FALSE,
    treated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    treated_at TIMESTAMP NULL,
    FOREIGN KEY (player_id) REFERENCES users(id),
    FOREIGN KEY (treated_by) REFERENCES users(id)
);

CREATE INDEX idx_injuries_player ON player_injuries(player_id);
CREATE INDEX idx_injuries_treated ON player_injuries(treated);
