-- Police Jail Schema

CREATE TABLE player_jail (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    officer_id INT NOT NULL,
    minutes INT NOT NULL,
    jailed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    release_time TIMESTAMP,
    released BOOLEAN DEFAULT FALSE,
    released_date TIMESTAMP NULL,
    FOREIGN KEY (player_id) REFERENCES users(id),
    FOREIGN KEY (officer_id) REFERENCES users(id)
);

CREATE INDEX idx_jail_player ON player_jail(player_id);
CREATE INDEX idx_jail_released ON player_jail(released);
CREATE INDEX idx_jail_release_time ON player_jail(release_time);
