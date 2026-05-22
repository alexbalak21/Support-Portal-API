# Load .env file
$envFile = ".\psql_conn.env"
if (-Not (Test-Path $envFile)) {
    Write-Host "psql_conn.env not found"
    exit 1
}

# Read the line
$line = Get-Content $envFile | Where-Object { $_ -match "psql_conn" }
$connectionString = $line.Split("=")[1].Trim('"')

# Parse the connection string
if ($connectionString -match "postgresql://([^:]+):([^@]+)@([^/]+)/(.+)$") {
    $pgUser = $matches[1]
    $pgPassword = $matches[2]
    $pgHost = $matches[3]
    $pgDb = $matches[4]
    $pgPort = 5432
} else {
    Write-Host "Invalid connection string format"
    exit 1
}

# Build psql command
$psqlCmd = "host=$pgHost port=$pgPort dbname=$pgDb user=$pgUser password=$pgPassword sslmode=require"

Write-Host "Connecting to PostgreSQL on Render..."
psql "$psqlCmd"
