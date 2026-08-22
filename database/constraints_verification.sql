--verify the created constraints
SELECT
    table_schema,
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'staging'
ORDER BY table_name, constraint_name;