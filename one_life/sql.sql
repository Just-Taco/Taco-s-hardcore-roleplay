CREATE TABLE IF NOT EXISTS death_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_license VARCHAR(50) NOT NULL UNIQUE,
    deaths INT NOT NULL
);
