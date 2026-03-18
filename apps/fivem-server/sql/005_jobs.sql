-- Job System Schema

CREATE TABLE job_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    job_name VARCHAR(50) NOT NULL,
    duration_minutes INT NOT NULL,
    pay_amount INT NOT NULL,
    clock_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    clock_out TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES users(id)
);

CREATE INDEX idx_job_player ON job_sessions(player_id);
CREATE INDEX idx_job_name ON job_sessions(job_name);
CREATE INDEX idx_job_timestamp ON job_sessions(clock_in);
