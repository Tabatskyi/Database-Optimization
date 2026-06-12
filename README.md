## Changelog

### Database Optimizations

* **Reverse B-Tree Indexing:** Replaced the unoptimized `LIKE '%gmail%'` query with an "ends-with" search (`LIKE REVERSE('%gmail.com')`) supported by a Reverse B-Tree index (`idx_cust_email_reverse`) for massive read-speed improvements.

* **Composite Indexing:** Created `idx_orders_status_city` on the `orders` table to instantly filter queries searching by `status` and `delivery_city`.

* **Time-Series Indexing:** Created `idx_events_time` on the `customer_events_wide` table to quickly prune data outside the 90-day window.

* **Materialized Views:** Migrated the expensive `heavy_join` and `events_aggregation` analytical queries into Materialized Views (`mv_customer_revenue` and `mv_customer_events_agg`).

* **Eliminated Deadlocks:** Updated the `deadlock_worker` function. Used `sorted()` to solve deadlock.

* **Lock Contention:** Removed explicit `LOCK TABLE orders IN SHARE ROW EXCLUSIVE MODE` command. Everythoing now relies on MVCC.

### How to Run
`docker compose up -d`
