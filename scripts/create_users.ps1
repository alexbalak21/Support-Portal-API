# Base URL
$baseUrl = "http://localhost:8100"
$baseUrl = "https://issue-tracker-vysg.onrender.com"

Write-Host "=== Creating Users ===" -ForegroundColor Cyan

# -----------------------------
# 1. Login as Admin
# -----------------------------
Write-Host "`n[1] Logging in as admin..."

$adminLoginBody = @{
    email = "admin@example.com"
    password = "admin123"
} | ConvertTo-Json

$adminLoginResponse = Invoke-RestMethod `
    -Uri "$baseUrl/api/auth/login" `
    -Method POST `
    -Body $adminLoginBody `
    -ContentType "application/json"

$adminAccessToken = $adminLoginResponse.data.access_token
Write-Host "Admin Access Token:" $adminAccessToken

$adminHeaders = @{ Authorization = "Bearer $adminAccessToken" }

# -----------------------------
# 2. Users to Create
# -----------------------------
$users = @(
    # Managers
    @{ name = "Michael Anderson"; email = "michael.anderson@example.com"; password = "password1234"; roleIds = @(4) },

    # Support
    @{ name = "Claire Dupont"; email = "claire.dupont@example.com"; password = "password1234"; roleIds = @(3) },
    @{ name = "Julien Morel"; email = "julien.morel@example.com"; password = "password1234"; roleIds = @(3) },
    @{ name = "Amelie Rousseau"; email = "amelie.rousseau@example.com"; password = "password1234"; roleIds = @(3) },

    # Normal Users
    @{ name = "Emma Johnson"; email = "emma.johnson@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Daniel Martin"; email = "daniel.martin@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Sophie Bernard"; email = "sophie.bernard@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Lucas Moreau"; email = "lucas.moreau@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Olivia Turner"; email = "olivia.turner@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Nathan Scott"; email = "nathan.scott@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Chloe Dubois"; email = "chloe.dubois@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Gabriel Lefevre"; email = "gabriel.lefevre@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Isabelle Laurent"; email = "isabelle.laurent@example.com"; password = "password1234"; roleIds = @(2) },
    @{ name = "Thomas Keller"; email = "thomas.keller@example.com"; password = "password1234"; roleIds = @(2) }
)

# -----------------------------
# 3. Create Users
# -----------------------------
$index = 1
foreach ($user in $users) {
    Write-Host "`n[$index] Creating user: $($user.name)..."

    $userBody = $user | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-RestMethod `
            -Uri "$baseUrl/api/admin/users" `
            -Headers $adminHeaders `
            -Method POST `
            -Body $userBody `
            -ContentType "application/json"

        Write-Host "Created:" ($response | ConvertTo-Json -Depth 5)
    }
    catch {
        Write-Host "Failed to create $($user.name): $($_.Exception.Message)" -ForegroundColor Yellow
    }

    $index++
}

Write-Host "`n=== User Creation Completed ===" -ForegroundColor Green
