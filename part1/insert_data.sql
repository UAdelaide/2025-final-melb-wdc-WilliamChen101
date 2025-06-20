
INSERT INTO users (username, email, password_hash, role) VALUES
('alice123', 'alice@example.com', 'hashed123', 'owner'),
('bobwalker', 'bob@example.com', 'hashed456', 'walker'),
('carol123', 'carol@example.com', 'hashed789', 'owner'),
('daviddog', 'david@example.com', 'hashed888', 'owner'),
('ellawalk', 'ella@example.com', 'cccded525', 'walker');


INSERT INTO dogs (name, size, owner_id) VALUES
('Max', 'medium', (SELECT user_id FROM users WHERE username = 'alice123')),
('Bella', 'small', (SELECT user_id FROM users WHERE username = 'carol123')),
('Rocky', 'large', (SELECT user_id FROM users WHERE username = 'daviddog')),
('Luna', 'small', (SELECT user_id FROM users WHERE username = 'banan123')),
('Buddy', 'medium', (SELECT user_id FROM users WHERE username = 'apply123'));


INSERT INTO walkrequests (dog_id, owner_id, requested_time, duration_minutes, location, status) VALUES
((SELECT dog_id FROM dogs WHERE name = 'Max'), (SELECT user_id FROM users WHERE username = 'alice123'), '2025-06-10 08:00:00', 30, 'Parklands', 'open'),
((SELECT dog_id FROM dogs WHERE name = 'Bella'), (SELECT user_id FROM users WHERE username = 'carol123'), '2025-06-10 09:30:00', 45, 'Beachside Ave', 'accepted'),
((SELECT dog_id FROM dogs WHERE name = 'Rocky'), (SELECT user_id FROM users WHERE username = 'daviddog'), '2025-06-11 10:00:00', 60, 'Lakeview Park', 'open'),
((SELECT dog_id FROM dogs WHERE name = 'Luna'), (SELECT user_id FROM users WHERE username = 'banan123'), '2025-06-12 07:30:00', 40, 'Hilltop Garden', 'pending'),
((SELECT dog_id FROM dogs WHERE name = 'Buddy'), (SELECT user_id FROM users WHERE username = 'apply123'), '2025-06-12 17:00:00', 25, 'Central Park', 'open');
