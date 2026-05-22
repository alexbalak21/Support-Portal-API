### Restore PostgreSQL database from backup.sql using connection string from psql_conn.env

param(
    [string]$file = ".\sql\backup.sql"
)

# --- Load .env file ---
$envFile = ".\psql_conn.env"
if (-Not (Test-Path $envFile)) {
    Write-Host "ERROR: psql_conn.env not found"
    exit 1
}

# --- Read the line containing psql_conn= ---
$raw = Get-Content $envFile -Encoding UTF8 | Select-String -Pattern 'psql_conn\s*=' | ForEach-Object { $_.ToString() }

if (-not $raw) {
    Write-Host "ERROR: psql_conn variable not found in .env file"
    exit 1
}

# --- Extract connection string ---
$connectionString = $raw -replace '.*psql_conn\s*=\s*', ''
$connectionString = $connectionString.Trim('"').Trim()

# --- Remove BOM and invisible characters ---
$connectionString = $connectionString -replace '[^\u0020-\u007E]', ''

if (-not $connectionString) {
    Write-Host "ERROR: Connection string is empty after parsing"
    exit 1
}

Write-Host "Connection string loaded:"
Write-Host "[$connectionString]"

# --- Extract username ---
if ($connectionString -match "postgresql://([^:]+):") {
    $pgUser = $matches[1]
} else {
    Write-Host "ERROR: Could not extract username from connection string"
    exit 1
}

Write-Host "Using DB user: $pgUser"

# --- Ensure backup file exists ---
if (-Not (Test-Path $file)) {
    Write-Host "ERROR: Backup file not found: $file"
    exit 1
}

# --- Remove BOM from original SQL file ---
(Get-Content $file -Encoding UTF8) | Set-Content $file -Encoding UTF8

# --- Prepare temporary SQL file ---
$tempFile = "$file.tmp"

# --- REMOVE ALTER DEFAULT PRIVILEGES lines ---
$cleanedSql = Get-Content $file -Encoding UTF8 | Where-Object {
    $_ -notmatch "ALTER DEFAULT PRIVILEGES"
}

# --- Replace placeholder __DB_USER__ ---
$cleanedSql = $cleanedSql -replace "__DB_USER__", $pgUser

# --- Save cleaned SQL ---
$cleanedSql | Set-Content $tempFile -Encoding UTF8

Write-Host "SQL cleaned and placeholder replaced with: $pgUser"

# --- Build final connection string (escape ? with backtick) ---
$finalConn = "$connectionString`?sslmode=require"

Write-Host "Final connection string passed to psql:"
Write-Host "[$finalConn]"

# --- Run restore ---
psql "$finalConn" -f $tempFile

# --- Cleanup ---
Remove-Item $tempFile -Force
Write-Host "Restore completed."
