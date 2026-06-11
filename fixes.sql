-- search_customer_by_email
CREATE INDEX idx_cust_email_reverse 
ON customers (REVERSE(email) varchar_pattern_ops);

-- orders_by_city_and_status
CREATE INDEX idx_orders_status_city ON orders(status, delivery_city);

-- cartesian_pressure
CREATE INDEX idx_events_time ON customer_events_wide(event_time);

-- heavy_join
CREATE MATERIALIZED VIEW mv_customer_revenue AS
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.status = 'active'
GROUP BY c.customer_id, c.full_name;

CREATE UNIQUE INDEX idx_mv_cust_rev_id ON mv_customer_revenue(customer_id);

-- events_aggregation
CREATE MATERIALIZED VIEW mv_customer_events_agg AS
SELECT
    customer_id,
    event_type,
    COUNT(*) AS events_count,
    MAX(event_time) AS last_event_time
FROM customer_events_wide
WHERE event_time >= NOW() - INTERVAL '180 days'
GROUP BY customer_id, event_type;

CREATE UNIQUE INDEX idx_mv_cust_evt_agg ON mv_customer_events_agg(customer_id, event_type);

-- cleanup
VACUUM ANALYZE customers;
VACUUM ANALYZE orders;
VACUUM ANALYZE customer_events_wide;