INSERT INTO campaign_spend (date, channel, campaign, spend, impressions, clicks) VALUES
('2026-01-01','Paid Search','Brand_Search_US',1200, 180000, 5400),
('2026-01-01','Social','Meta_Prospecting',900,  250000, 2800),
('2026-01-01','Email','Newsletter_Jan',120,  45000,  900),
('2026-01-01','Display','DV360_Retargeting',700, 380000, 1600),
('2026-01-01','Organic','SEO_Blog',0,    90000,  2200),

('2026-01-02','Paid Search','Brand_Search_US',1100, 175000, 5200),
('2026-01-02','Social','Meta_Prospecting',950,  260000, 3000),
('2026-01-02','Email','Newsletter_Jan',80,   42000,  820),
('2026-01-02','Display','DV360_Retargeting',650, 360000, 1500),
('2026-01-02','Organic','SEO_Blog',0,    92000,  2300),

('2026-01-03','Paid Search','NonBrand_Search_US',1500, 210000, 6000),
('2026-01-03','Social','Meta_Retargeting',600,  140000, 2100),
('2026-01-03','Email','AbandonCart',140,  16000,  520),
('2026-01-03','Display','DV360_Prospecting',900, 520000, 1900),
('2026-01-03','Organic','SEO_Blog',0,    95000,  2400);

INSERT INTO web_events (user_id, session_id, timestamp, event_type, source_medium) VALUES
('u1','s1','2026-01-01 14:00:00+00','visit','display / cpm'),
('u1','s1','2026-01-01 14:05:00+00','add_to_cart','display / cpm'),
('u1','s2','2026-01-02 16:10:00+00','visit','paid search / cpc'),
('u1','s2','2026-01-02 16:25:00+00','purchase','paid search / cpc'),

('u2','s3','2026-01-01 18:00:00+00','visit','social / paid'),
('u2','s3','2026-01-01 18:20:00+00','visit','social / paid'),
('u2','s4','2026-01-03 13:00:00+00','visit','email / newsletter'),
('u2','s4','2026-01-03 13:10:00+00','add_to_cart','email / newsletter'),
('u2','s4','2026-01-03 13:15:00+00','purchase','email / newsletter'),

('u3','s5','2026-01-02 09:00:00+00','visit','organic / search'),
('u3','s6','2026-01-03 09:40:00+00','visit','paid search / cpc'),

('u4','s7','2026-01-02 20:00:00+00','visit','display / cpm'),
('u4','s7','2026-01-02 20:10:00+00','visit','display / cpm'),

('u5','s8','2026-01-03 22:00:00+00','visit','organic / search'),
('u5','s8','2026-01-03 22:08:00+00','add_to_cart','organic / search');

INSERT INTO conversions (user_id, conversion_time, order_id, revenue) VALUES
('u1','2026-01-02 16:25:00+00','o1001',180.50),
('u2','2026-01-03 13:15:00+00','o1002',95.00);
