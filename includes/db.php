<?php
declare(strict_types=1);

require_once __DIR__ . '/config.php';

/**
 * Singleton PDO connection. Uses prepared statements only.
 */
function db(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = sprintf(
        'mysql:host=%s;dbname=%s;charset=%s',
        DB_HOST, DB_NAME, DB_CHARSET
    );

    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::ATTR_PERSISTENT         => false,
    ];

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
    } catch (PDOException $e) {
        error_log('[DB] ' . $e->getMessage());
        http_response_code(500);
        exit('Database connection error.');
    }
    return $pdo;
}

/**
 * Run a prepared statement and return all rows.
 *
 * @param string $sql
 * @param array<string|int,mixed> $params
 * @return array<int,array<string,mixed>>
 */
function db_all(string $sql, array $params = []): array
{
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

/**
 * Run a prepared statement and return a single row (or null).
 *
 * @param string $sql
 * @param array<string|int,mixed> $params
 * @return array<string,mixed>|null
 */
function db_one(string $sql, array $params = []): ?array
{
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    $row = $stmt->fetch();
    return $row === false ? null : $row;
}

/**
 * Run a prepared INSERT/UPDATE/DELETE and return affected row count.
 *
 * @param string $sql
 * @param array<string|int,mixed> $params
 */
function db_exec(string $sql, array $params = []): int
{
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    return $stmt->rowCount();
}

function db_last_id(): int
{
    return (int) db()->lastInsertId();
}
