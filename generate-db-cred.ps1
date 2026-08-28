# Input file
$envFile = ".\psql_conn.env"

if (-Not (Test-Path $envFile)) {
    Write-Host "ERROR: psql_conn.env not found"
    exit 1
}

# Read the line containing psql_conn=
$raw = Get-Content $envFile -Encoding UTF8 | Select-String -Pattern 'psql_conn\s*=' | ForEach-Object { $_.ToString().Trim() }

if (-not $raw) {
    Write-Host "ERROR: psql_conn variable not found"
    exit 1
}

# Extract the URL (supports quoted and unquoted formats)
$connectionString = $raw -replace '.*psql_conn\s*=\s*', '' -replace '^"', '' -replace '"$', ''

# Parse the connection string
# Supports:
# postgresql://user:pass@host/database
# postgresql://user:pass@host:port/database
if ($connectionString -match "^postgresql://([^:]+):([^@]+)@([^/]+?)(?::(\d+))?/(.+)$") {
    $username = $matches[1]
    $password = $matches[2]
    $dbHost   = $matches[3]          # FULL host preserved
    $port     = if ($matches[4]) { $matches[4] } else { "5432" }
    $database = $matches[5]
} else {
    Write-Host "ERROR: Could not parse connection string"
    Write-Host "STRING READ: $connectionString"
    exit 1
}

# Build JDBC URL
$jdbcUrl = "jdbc:postgresql://$dbHost`:$port/$database"

# Output file
$outFile = ".\db_cred_env.txt"

$content = @"
database = $database
port = $port
username = $username
password = $password
DATABASE_URL=$jdbcUrl
"@

# Write to file
$content | Set-Content $outFile -Encoding UTF8

# Print to console
Write-Host "`nGenerated db_cred_env.txt:"
Write-Host "-------------------------------------"
Write-Host $content
