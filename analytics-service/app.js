const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

let analytics = [];

app.post('/track', (req, res) => {
    analytics.push(req.body);
    res.json({ message: 'Event recorded' });
});

app.get('/analytics', (req, res) => {
    res.json(analytics);
});

const PORT = process.env.PORT || 5002;
app.listen(PORT, () => console.log(`Analytics service running on port ${PORT}`));

