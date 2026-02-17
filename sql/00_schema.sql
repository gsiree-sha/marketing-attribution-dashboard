DROP TABLE IF EXISTS conversions;
DROP TABLE IF EXISTS web_events;
DROP TABLE IF EXISTS campaign_spend;

CREATE TABLE campaign_spend (
  date         DATE NOT NULL,
  channel      TEXT NOT NULL CHECK (channel IN ('Paid Search','Social','Email','Display','Organic')),
  campaign     TEXT NOT NULL,
  spend        NUMERIC(12,2) NOT NULL CHECK (spend >= 0),
  impressions  BIGINT NOT NULL CHECK (impressions >= 0),
  clicks       BIGINT NOT NULL CHECK (clicks >= 0),
  PRIMARY KEY (date, channel, campaign)
);

CREATE TABLE web_events (
  user_id       TEXT NOT NULL,
  session_id    TEXT NOT NULL,
  timestamp     TIMESTAMPTZ NOT NULL,
  event_type    TEXT NOT NULL CHECK (event_type IN ('visit','add_to_cart','purchase')),
  source_medium TEXT NOT NULL,
  PRIMARY KEY (session_id, timestamp, event_type)
);

CREATE TABLE conversions (
  user_id         TEXT NOT NULL,
  conversion_time TIMESTAMPTZ NOT NULL,
  order_id        TEXT NOT NULL PRIMARY KEY,
  revenue         NUMERIC(12,2) NOT NULL CHECK (revenue >= 0)
);

CREATE INDEX idx_web_events_user_time ON web_events(user_id, timestamp);
CREATE INDEX idx_web_events_source ON web_events(source_medium);
CREATE INDEX idx_conversions_user_time ON conversions(user_id, conversion_time);
CREATE INDEX idx_spend_channel_date ON campaign_spend(channel, date);
