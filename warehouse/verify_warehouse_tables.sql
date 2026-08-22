--verify the warehouse tables
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'warehouse'
ORDER BY table_name;