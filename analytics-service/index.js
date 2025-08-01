const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { createClient } = require('@clickhouse/client');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());
app.use(cors());

// ClickHouse client
const clickhouse = createClient({
  host: process.env.CLICKHOUSE_HOST,
  username: process.env.CLICKHOUSE_USER,
  password: process.env.CLICKHOUSE_PASS,
});

// Create table if it doesn't exist
(async () => {
  try {
    await clickhouse.query({
      query: `
        CREATE TABLE IF NOT EXISTS pageviews
        (
          url String,
          eventType String,
          timestamp DateTime,
          element String DEFAULT '',
          durationMs UInt32 DEFAULT 0
        )
        ENGINE = MergeTree()
        ORDER BY timestamp
      `,
      format: 'JSON',
    });
    console.log('ClickHouse table ready');
  } catch (err) {
    console.error('Error creating ClickHouse table:', err);
  }
})();

// POST endpoint to insert analytics data
app.post('/analytics', async (req, res) => {
  try {
    const timestamp = req.body.timestamp
      ? new Date(req.body.timestamp).toISOString()
      : new Date().toISOString();

    await clickhouse.insert({
      table: 'pageviews',
      values: [
        {
          url: req.body.url || '',
          eventType: req.body.eventType || '',
          timestamp: timestamp, // formatted as ISO string
          element: req.body.element || '',
          durationMs: req.body.durationMs || 0,
        },
      ],
      format: 'JSONEachRow',
    });

    res.status(201).json({ message: 'Analytics event stored successfully' });
  } catch (err) {
    console.error('Error inserting data:', err);
    res.status(500).json({ error: 'Failed to insert data' });
  }
});

// GET endpoint to fetch recent analytics
app.get('/analytics', async (req, res) => {
  try {
    const result = await clickhouse.query({
      query: `SELECT url, eventType, timestamp, element, durationMs FROM pageviews ORDER BY timestamp DESC LIMIT 50`,
      format: 'JSONEachRow',
    });

    const rows = await result.json(); // Parses rows automatically

    res.status(200).json(rows);
  } catch (err) {
    console.error('Error fetching data:', err);
    res.status(500).json({ error: 'Failed to fetch analytics data' });
  }
});

app.listen(3003, () =>
  console.log('Analytics Service running on port 3003')
);
