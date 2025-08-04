const axios = require('axios');

// Use BASE_URL from environment or fallback to working URL
const BASE_URL =
  process.env.BASE_URL ||
  'http://a876ee0fe94684e3ab6d79bc0bfd8221-763110057.eu-north-1.elb.amazonaws.com';

console.log(`Running integration tests with BASE_URL: ${BASE_URL}`);

test('Frontend is reachable', async () => {
  const res = await axios.get(`${BASE_URL}/`);
  expect(res.status).toBe(200);
});

test('Game service endpoint returns data', async () => {
  const res = await axios.get(`${BASE_URL}/games`);
  expect(res.status).toBe(200);
});
