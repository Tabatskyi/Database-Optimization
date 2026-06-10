 -- CREATE EXTENSION pg_stat_statements; -- If not exitsts in current DB

SELECT
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 100;

-- Identify blocked sessions and their corresponding blocking sessions

SELECT
    blocked.pid AS blocked_pid,
    blocked.usename AS blocked_user,
    blocked.query AS blocked_query,
    blocking.pid AS blocking_pid,
    blocking.usename AS blocking_user,
    blocking.query AS blocking_query,
    blocked.wait_event_type,
    blocked.wait_event
FROM pg_stat_activity blocked
JOIN pg_stat_activity blocking
ON blocking.pid = ANY(pg_blocking_pids(blocked.pid))
ORDER BY blocked.pid;

-- Detect long-running transactions that may be causing lock contention

SELECT
    pid,
    usename,
    state,
    xact_start,
    now() - xact_start AS transaction_duration,
    query
FROM pg_stat_activity
WHERE xact_start IS NOT NULL
ORDER BY xact_start;

-- List active sessions currently waiting to acquire a lock

SELECT
    pid,
    usename,
    state,
    wait_event_type,
    wait_event,
    query_start,
    now() - query_start AS running_for,
    query
FROM pg_stat_activity
WHERE wait_event_type = 'Lock';