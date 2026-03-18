# Tools Directory

Development tools, profiling, and testing utilities.

## Contents

### profiling/
Performance profiling and optimization tools.

**Use for:**
- Identify slow queries
- CPU/Memory usage analysis
- Database profiling
- Resource optimization
- Bottleneck detection

**Tools:**
- Flame graphs
- Memory snapshots
- Query analysis scripts

### testing/
Test suites and test infrastructure.

**Coverage:**
- Unit tests
- Integration tests
- Load tests
- API tests

**Frameworks:**
- Jest (unit testing)
- Supertest (HTTP testing)
- Artillery (load testing)

## Running Tests

```bash
# All tests
npm test

# Specific test file
npm test -- character.test.js

# With coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

## Performance Profiling

### CPU Profile
```bash
node --prof server.js
node --prof-process isolate-*.log > profile.txt
```

### Memory Profile
```bash
node --inspect server.js
# Open chrome://inspect in browser
```

### Database Query Analysis
```bash
# Enable query logging
SET log_statement = 'all';

# View slow queries
SELECT * FROM pg_stat_statements ORDER BY total_time DESC;
```

## Load Testing

```bash
# Install Artillery
npm install -g artillery

# Create load test scenario
# See tools/testing/scenarios/

# Run test
artillery run tools/testing/scenarios/loadtest.yml
```

## Adding Tests

### Unit Test Example
```javascript
// tests/economy.test.js
describe('Economy System', () => {
  test('should add money to player', () => {
    const player = {money: 100};
    addMoney(player, 50);
    expect(player.money).toBe(150);
  });
});
```

### Integration Test
```javascript
test('should create business', async () => {
  const response = await request(app)
    .post('/api/businesses')
    .send({name: 'Test', type: 'restaurant'});
  expect(response.status).toBe(201);
});
```

## Performance Targets

- **API Response**: < 200ms
- **Database Query**: < 100ms avg
- **Memory Usage**: < 500MB
- **CPU Usage**: < 50%
- **Throughput**: 100+ req/sec

## CI/CD Integration

Tests run automatically on:
- Pull requests
- Commits to main/develop
- Manual trigger

See `/ci/` for workflow configuration.

## Monitoring in Production

```bash
# View application metrics
docker-compose exec admin-api npm run profile

# Database stats
docker-compose exec postgres psql -U fivem -d fivem_db -c "SELECT * FROM pg_stat_statements;"

# Memory usage
docker stats
```

See `/docs/operations/` for monitoring guides.
