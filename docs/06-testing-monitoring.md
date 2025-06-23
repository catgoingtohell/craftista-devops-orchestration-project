
# 6. Testing & Monitoring

## Testing Strategy

### Testing Pyramid Implementation

```
                    ┌─────────────────┐
                    │   E2E Tests     │
                    │   (Manual)      │
                    └─────────────────┘
                ┌─────────────────────────┐
                │  Integration Tests      │
                │   (API Testing)         │
                └─────────────────────────┘
            ┌─────────────────────────────────┐
            │        Unit Tests               │
            │   (Component Testing)           │
            └─────────────────────────────────┘
```

### Unit Testing

#### Framework and Configuration
```json
Testing Stack:
- Framework: Vitest/Jest
- React Testing: React Testing Library
- Coverage: Istanbul/c8
- Mocking: Vitest Mock Functions
```

#### Test Categories
```typescript
// Component Tests
describe('Button Component', () => {
  test('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });
  
  test('handles click events', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});

// Utility Tests
describe('Math Operations', () => {
  test('calculates correctly', () => {
    expect(add(2, 3)).toBe(5);
    expect(multiply(4, 5)).toBe(20);
  });
});
```

#### Coverage Requirements
```yaml
Coverage Targets:
- Statements: >90%
- Branches: >85%
- Functions: >90%
- Lines: >90%
```

### Integration Testing

#### API Testing
```javascript
// API Integration Tests
describe('API Integration', () => {
  test('fetches user data', async () => {
    const mockData = { id: 1, name: 'John Doe' };
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => mockData,
    });
    
    const result = await fetchUserData(1);
    expect(result).toEqual(mockData);
  });
});
```

#### Component Integration
```javascript
// Component Integration Tests
describe('User Profile Integration', () => {
  test('displays user information correctly', async () => {
    render(<UserProfile userId={1} />);
    
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
  });
});
```

### End-to-End Testing

#### Testing Framework
```yaml
E2E Testing Stack:
- Framework: Cypress (recommended for future implementation)
- Alternative: Playwright
- Browser: Chrome, Firefox, Safari
- Environment: Staging environment
```

#### Test Scenarios
```javascript
// Critical User Journeys
describe('User Authentication Flow', () => {
  it('should allow user to login successfully', () => {
    cy.visit('/login');
    cy.get('[data-testid=email]').type('user@example.com');
    cy.get('[data-testid=password]').type('password123');
    cy.get('[data-testid=login-button]').click();
    cy.url().should('include', '/dashboard');
  });
});
```

### CI/CD Testing Pipeline

#### GitHub Actions Test Configuration
```yaml
Test Pipeline Stages:
1. Dependency Installation
2. Lint Check (ESLint)
3. Type Check (TypeScript)
4. Unit Tests (Vitest)
5. Build Verification
6. Integration Tests
7. Security Scanning
```

#### Pipeline Configuration
```yaml
name: Test Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linting
        run: npm run lint
      
      - name: Run type checking
        run: npm run type-check
      
      - name: Run unit tests
        run: npm run test:coverage
      
      - name: Build application
        run: npm run build
```

## Monitoring Strategy

### Application Monitoring

#### Metrics Collection
```yaml
Application Metrics:
├── Performance Metrics
│   ├── Response Time (avg, p95, p99)
│   ├── Request Rate (req/sec)
│   ├── Error Rate (%)
│   └── Throughput (operations/sec)
├── Business Metrics
│   ├── Active Users
│   ├── Feature Usage
│   ├── Conversion Rates
│   └── User Journey Analytics
└── Technical Metrics
    ├── Bundle Size
    ├── Load Time
    ├── Memory Usage
    └── CPU Usage
```

#### Custom Metrics Implementation
```javascript
// Custom Metrics Example
import { prometheus } from './monitoring/prometheus';

// Request counter
const requestCounter = prometheus.counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Response time histogram
const responseTimeHistogram = prometheus.histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route']
});

// Middleware for metrics collection
export const metricsMiddleware = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    requestCounter
      .labels(req.method, req.route.path, res.statusCode)
      .inc();
    
    responseTimeHistogram
      .labels(req.method, req.route.path)
      .observe(duration);
  });
  
  next();
};
```

### Infrastructure Monitoring

#### Kubernetes Metrics
```yaml
K8s Monitoring Targets:
├── Node Metrics
│   ├── CPU Usage
│   ├── Memory Usage
│   ├── Disk I/O
│   └── Network Traffic
├── Pod Metrics
│   ├── Pod Status
│   ├── Restart Count
│   ├── Resource Usage
│   └── Health Checks
├── Cluster Metrics
│   ├── API Server Response Time
│   ├── etcd Performance
│   ├── Scheduler Latency
│   └── Network Policies
└── Application Metrics
    ├── Container Resources
    ├── Service Discovery
    ├── Ingress Traffic
    └── Storage Usage
```

#### Prometheus Configuration
```yaml
# prometheus-config.yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true

  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

### Grafana Dashboards

#### Application Dashboard
```json
{
  "dashboard": {
    "title": "Craftista Application Metrics",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{route}}"
          }
        ]
      },
      {
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "singlestat",
        "targets": [
          {
            "expr": "rate(http_requests_total{status_code=~\"5..\"}[5m]) / rate(http_requests_total[5m]) * 100",
            "legendFormat": "Error Rate %"
          }
        ]
      }
    ]
  }
}
```

#### Infrastructure Dashboard
```json
{
  "dashboard": {
    "title": "Kubernetes Cluster Metrics",
    "panels": [
      {
        "title": "Pod Status",
        "type": "table",
        "targets": [
          {
            "expr": "kube_pod_status_phase",
            "legendFormat": "{{pod}} - {{phase}}"
          }
        ]
      },
      {
        "title": "Node CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100",
            "legendFormat": "{{instance}}"
          }
        ]
      }
    ]
  }
}
```

### Alerting Strategy

#### Alert Rules
```yaml
groups:
  - name: application.rules
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status_code=~"5.."}[5m]) / rate(http_requests_total[5m]) * 100 > 10
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }}% for the last 5 minutes"

      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time detected"
          description: "95th percentile response time is {{ $value }}s"

      - alert: PodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
        for: 0m
        labels:
          severity: critical
        annotations:
          summary: "Pod is crash looping"
          description: "Pod {{ $labels.pod }} in namespace {{ $labels.namespace }} is restarting frequently"

  - name: infrastructure.rules
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is {{ $value }}% on {{ $labels.instance }}"

      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage detected"
          description: "Memory usage is {{ $value }}% on {{ $labels.instance }}"
```

#### Notification Channels
```yaml
Alerting Channels:
├── Slack Integration
│   ├── #alerts channel for critical alerts
│   ├── #monitoring channel for warnings
│   └── Direct messages for on-call engineers
├── Email Notifications
│   ├── Team distribution list
│   ├── Manager notifications for critical alerts
│   └── Weekly summary reports
└── PagerDuty Integration
    ├── Incident escalation
    ├── On-call rotation
    └── Incident tracking
```

### Logging Strategy

#### Log Levels and Categories
```yaml
Log Levels:
- ERROR: System errors, exceptions
- WARN: Potential issues, deprecations
- INFO: General application flow
- DEBUG: Detailed debugging information

Log Categories:
- Application: Business logic logs
- Security: Authentication, authorization
- Performance: Slow queries, bottlenecks
- Infrastructure: System-level events
```

#### Log Aggregation
```yaml
Logging Stack:
├── Collection: Fluentd/Fluent Bit
├── Storage: Elasticsearch
├── Visualization: Kibana
└── Alerting: ElastAlert
```

### Performance Testing

#### Load Testing Strategy
```javascript
// Load Testing with Artillery (example)
config:
  target: 'https://craftista.yourdomain.com'
  phases:
    - duration: 60
      arrivalRate: 10
    - duration: 120
      arrivalRate: 50
    - duration: 60
      arrivalRate: 100

scenarios:
  - name: "Homepage Load Test"
    flow:
      - get:
          url: "/"
      - think: 2
      - get:
          url: "/api/health"
```

#### Performance Metrics
```yaml
Performance Targets:
- Page Load Time: <2 seconds
- API Response Time: <200ms (95th percentile)
- Time to First Byte: <800ms
- Largest Contentful Paint: <2.5s
- First Input Delay: <100ms
- Cumulative Layout Shift: <0.1
```

### Monitoring Best Practices

#### Data Retention
```yaml
Retention Policies:
- Metrics: 30 days (high resolution), 1 year (downsampled)
- Logs: 14 days (application), 30 days (security)
- Traces: 7 days (distributed tracing)
- Alerts: 90 days (alert history)
```

#### Dashboard Design Principles
1. **Hierarchy**: Critical metrics at the top
2. **Context**: Related metrics grouped together
3. **Actionability**: Each metric should lead to an action
4. **Clarity**: Clear labels and units
5. **Performance**: Fast loading dashboards

#### Monitoring Automation
```bash
# Automated dashboard deployment
kubectl apply -f monitoring/grafana-dashboard-configmap.yaml

# Automated alert rule updates
kubectl apply -f monitoring/prometheus-rules-configmap.yaml

# Monitoring stack health checks
kubectl get pods -n monitoring
kubectl logs -f deployment/prometheus-server -n monitoring
```
