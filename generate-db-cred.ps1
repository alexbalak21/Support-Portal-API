## Script to generate db_cred_env.txt from psql_conn.env

# Put (copy) the external database credentials from render in psql_conn.env in the format:
# psql_conn="postgresql://username:password@host:port/database"

# Input file
$envFile = ".\psql_conn.env"

if (-Not (Test-Path $envFile)) {
    Write-Host "ERROR: psql_conn.env not found"
    exit 1
}

# Read the line containing psql_conn=
$raw = Get-Content $envFile -Encoding UTF8 | Select-String -Pattern 'psql_conn\s*=' | ForEach-Object { $_.ToString() }

if (-not $raw) {
    Write-Host "ERROR: psql_conn variable not found"
    exit 1
}

# Extract the URL inside the quotes
$connectionString = $raw -replace '.*psql_conn\s*=\s*"', '' -replace '"$', ''

# Parse the connection string
# Format: postgresql://user:pass@host:port/dbname
if ($connectionString -match "^postgresql://([^:]+):([^@]+)@([^:/]+):?(\d+)?/(.+)$") {
    $username = $matches[1]
    $password = $matches[2]
    $dbHost   = ($matches[3] -split '\.')[0]   # FIXED
    $port     = if ($matches[4]) { $matches[4] } else { "5432" }
    $database = $matches[5]
} else {
    Write-Host "ERROR: Could not parse connection string"
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
