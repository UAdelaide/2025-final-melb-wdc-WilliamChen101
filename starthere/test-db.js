const mysql = require('mysql2/promise');

async function testDB() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Chenweiyu101',
    database: 'DogWalkService'
  });

  const [rows] = await connection.execute('SELECT * FROM Users');
  console.log('Users:', rows);

  const [dogs] = await connection.execute('SELECT * FROM Dogs');
  console.log('Dogs:', dogs);

  const [requests] = await connection.execute('SELECT * FROM WalkRequests');
  console.log('Walk Requests:', requests);

  await connection.end();
}

testDB().catch(console.error);