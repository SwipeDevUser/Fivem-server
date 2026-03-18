const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.get('/', (req, res) => res.send('FiveM Server - Health Check OK'));

app.listen(port, () => console.log(`FiveM Server listening on port ${port}`));
