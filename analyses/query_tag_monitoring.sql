/*
Query Tag Monitoring Examples
These queries help you analyze query performance, costs, and usage patterns using the tags we've implemented.
*/

-- 1. Monitor dbt model performance by domain
SELECT 
    query_tag:application::string as application,
    query_tag:domain::string as domain,
    query_tag:model::string as model_name,
    query_tag:layer::string as layer,
    COUNT(*) as query_count,
    AVG(total_elapsed_time) as avg_runtime_ms,
    SUM(credits_used_cloud_services) as total_credits,
    MAX(start_time) as last_run
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 7
  AND query_tag:domain IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY total_credits DESC;

-- 2. Cost allocation by model refresh frequency
SELECT 
    query_tag:refresh::string as refresh_frequency,
    query_tag:domain::string as domain,
    COUNT(DISTINCT query_tag:model::string) as unique_models,
    COUNT(*) as total_queries,
    SUM(credits_used_cloud_services) as total_credits,
    AVG(total_elapsed_time) as avg_runtime_ms
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 30
  AND query_tag:refresh IS NOT NULL
GROUP BY 1, 2
ORDER BY total_credits DESC;

-- 3. Monitor staging vs marts layer performance
SELECT 
    query_tag:layer::string as layer,
    query_tag:environment::string as environment,
    COUNT(*) as query_count,
    AVG(total_elapsed_time) as avg_runtime_ms,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_elapsed_time) as p95_runtime_ms,
    SUM(credits_used_cloud_services) as total_credits
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 7
  AND query_tag:layer IS NOT NULL
GROUP BY 1, 2
ORDER BY layer, environment;

-- 4. Track model complexity and performance correlation
SELECT 
    query_tag:complexity::string as complexity,
    query_tag:model_type::string as model_type,
    COUNT(*) as query_count,
    AVG(total_elapsed_time) as avg_runtime_ms,
    AVG(credits_used_cloud_services) as avg_credits
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 7
  AND query_tag:complexity IS NOT NULL
GROUP BY 1, 2
ORDER BY avg_runtime_ms DESC;

-- 5. Daily query pattern analysis by user and environment  
SELECT 
    DATE(start_time) as query_date,
    query_tag:user::string as user_name,
    query_tag:environment::string as environment,
    COUNT(*) as daily_query_count,
    SUM(credits_used_cloud_services) as daily_credits,
    COUNT(DISTINCT query_tag:model::string) as unique_models_run
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 14
GROUP BY 1, 2, 3
ORDER BY query_date DESC, daily_credits DESC;

-- 6. Failed query analysis by model and domain
SELECT 
    query_tag:domain::string as domain,
    query_tag:model::string as model_name,
    execution_status,
    error_code,
    error_message,
    COUNT(*) as failure_count,
    MAX(start_time) as last_failure
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 7
  AND execution_status != 'SUCCESS'
GROUP BY 1, 2, 3, 4, 5
ORDER BY failure_count DESC;

-- 7. Hourly model refresh monitoring (for hourly tagged models)
SELECT 
    DATE_TRUNC('hour', start_time) as hour_bucket,
    query_tag:model::string as model_name,
    COUNT(*) as run_count,
    AVG(total_elapsed_time) as avg_runtime_ms,
    CASE 
        WHEN COUNT(*) = 0 THEN 'MISSING'
        WHEN COUNT(*) = 1 THEN 'ON_SCHEDULE' 
        WHEN COUNT(*) > 1 THEN 'MULTIPLE_RUNS'
    END as run_status
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND query_tag:refresh = 'hourly'
  AND start_time >= current_date - 3
GROUP BY 1, 2
ORDER BY hour_bucket DESC, model_name; 