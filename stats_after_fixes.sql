-- original bad query
EXPLAIN ANALYZE SELECT c.customer_id, c.full_name, 
                COUNT(o.order_id) AS orders_count, 
                SUM(o.total_amount) AS revenue 
                FROM customers c 
                JOIN orders o 
                ON c.customer_id = o.customer_id 
                WHERE c.status = 'active' 
                GROUP BY c.customer_id, c.full_name;

-- optimized
EXPLAIN ANALYZE SELECT * FROM mv_customer_revenue;