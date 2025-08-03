const axios = require('axios');

const BASE_URL = 'http://a44c43a34eb1e4115a0d0e3ac44d88b8-388466587.eu-north-1.elb.amazonaws.com';

test('Frontend is reachable', async () => {
  const res = await axios.get(`${BASE_URL}/`);
  expect(res.status).toBe(200);
});

test('Game service endpoint returns data', async () => {
  const res = await axios.get(`${BASE_URL}/games`);
  expect(res.status).toBe(200);
});
