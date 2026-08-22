SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN (
    'staging',
    'warehouse',
    'analytics'
)
ORDER BY schema_name;