const express = require('express');
const sql = require('mssql');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// SQL Server configuration
const sqlConfig = {
    user: process.env.SQL_USER || 'sqladminuser',
    password: process.env.SQL_PASSWORD || 'P@$$w0rd12345',
    server: process.env.SQL_SERVER || 'kalliopidemosqlserver.database.windows.net',
    database: process.env.SQL_DATABASE || 'kalliopidemosqldb',
    options: {
        encrypt: true,
        trustServerCertificate: false
    }
};

// Database connection pool
let pool;

// Initialize database connection
async function initDb() {
    try {
        pool = await sql.connect(sqlConfig);
        console.log('Connected to Azure SQL Database');
    } catch (err) {
        console.error('Database connection error:', err);
    }
}

initDb();

// API Routes

// Get all games
app.get('/api/games', async (req, res) => {
    try {
        const result = await pool.request()
            .query('SELECT Id, GameName, Studio, CreatedAt FROM Games ORDER BY CreatedAt DESC');
        res.json(result.recordset);
    } catch (err) {
        console.error('Error fetching games:', err);
        res.status(500).json({ error: 'Failed to fetch games' });
    }
});

// Add a new game
app.post('/api/games', async (req, res) => {
    try {
        const { name, studio } = req.body;
        
        if (!name || !studio) {
            return res.status(400).json({ error: 'Name and studio are required' });
        }

        const result = await pool.request()
            .input('name', sql.NVarChar, name)
            .input('studio', sql.NVarChar, studio)
            .query('INSERT INTO Games (GameName, Studio) OUTPUT INSERTED.* VALUES (@name, @studio)');
        
        res.status(201).json(result.recordset[0]);
    } catch (err) {
        console.error('Error adding game:', err);
        res.status(500).json({ error: 'Failed to add game' });
    }
});

// Delete a game
app.delete('/api/games/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        await pool.request()
            .input('id', sql.Int, id)
            .query('DELETE FROM Games WHERE Id = @id');
        
        res.status(200).json({ message: 'Game deleted successfully' });
    } catch (err) {
        console.error('Error deleting game:', err);
        res.status(500).json({ error: 'Failed to delete game' });
    }
});

// Serve index.html for root path
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
