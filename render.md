Render database restore procedure

1. Connect to Render.
2. Create a new database.
3. Copy the External Database URL from Render and put it in `psql_conn.env` in this format:

    psql_conn="postgresql://app_db_tgmh_user:RPa6h0a1lTqiaUtt038nZ30Mvxg0Iows@dpg-d8818umk1jcs73e8tm20-a.frankfurt-postgres.render.com/app_db_tgmh"

4. Test the connection with `connect_psql.ps1`.
5. If the connection works, run `restore_psql.ps1` to restore the data into the new database.

Files involved
- `psql_conn.env`
- `connect_psql.ps1`
- `restore_psql.ps1`
- `sql/backup.sql`
