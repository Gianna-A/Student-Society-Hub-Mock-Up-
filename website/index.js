/*
   Initial inspiration for this came from Joe's tutorial on December 5, 2023.
   Significant modifications, expansions, and reworkings have been applied.
*/
const express = require('express');
const ejs = require('ejs');
const mysql = require("mysql");
const util = require("util");
const bodyParser = require('body-parser');

const PORT = 8000;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_NAME = 'coursework';
const DB_PASSWORD = '';
const DB_PORT = 3306;

var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT,
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
	if (err) {
		console.error("error connecting: " + err.stack);
		return;
	}
	console.log("You're connected");
});

const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {

	const studentCount = await connection.query('SELECT COUNT(*) as count FROM Student');
	const societyCount = await connection.query('SELECT COUNT(*) as count FROM Society');
	const eventCount = await connection.query('SELECT COUNT(*) as count FROM Event');
	res.render('index', {
		studentCount: studentCount[0].count,
		societyCount: societyCount[0].count,
		eventCount: eventCount[0].count
	});
});


app.get('/students', async (req, res) => {
	const students = await connection.query(
		"SELECT * FROM Student INNER JOIN Course ON student.Stu_Course = course.Crs_Code"
	)
	res.render('students', { students: students });

});

app.get('/events', async (req, res) => {
	const events = await connection.query(
		"SELECT * FROM Event e INNER JOIN Society s ON s.Soc_ID = e.Soc_ID"
	)
	res.render('events', { events: events });

});

app.get('/societies', async (req, res) => {
	const societies = await connection.query(
		"SELECT * FROM Society"
	)
	res.render('societies', { societies: societies });

});


app.get("/students/view/:id", async (req, res) => {
	const student = await connection.query(
		"SELECT * FROM Student s INNER JOIN Course c ON s.Stu_Course = c.Crs_Code WHERE s.URN = ?",
		[req.params.id]
	);
	const hobbies = await connection.query(
	"SELECT * FROM Student s JOIN Engages_In e ON s.URN = e.URN JOIN Hobby h ON e.Hobby_No = h.Hobby_No WHERE s.URN = ?",
	[req.params.id]
	);

	const societies = await connection.query(
		"SELECT * FROM Student s JOIN Joins j ON s.URN = j.URN JOIN Society y ON y.Soc_ID = j.Soc_ID WHERE s.URN = ?",
	[req.params.id]
	)
	res.render("student_view", { 
		student: student[0], 
		hobbies: hobbies,
		societies: societies,
	});
});

app.get("/students/edit/:id", async (req, res) => {
	const courses = await connection.query('SELECT * FROM Course',);
	const student = await connection.query(
	"SELECT * FROM Student WHERE URN = ?",
	[req.params.id]
	);
	res.render("student_edit", {
	student: student[0],
	courses: courses,
	message: "",
	});
	
});

app.post("/students/hobbies/:id", async (req, res) => {
	var message = "";
	const hobby = await connection.query(
	"SELECT * FROM Student s",
	"JOIN Engages_In e ON s.URN = e.URN",
	"JOIN Hobby h ON h.Hobby_No = e.Hobby_No",
	"WHERE s.URN = ?",
	[req.params.id]
	);
	const courses = await connection.query("SELECT * FROM Course");
	res.render("hobbies", {student: student[0]});
});

app.post("/students/edit/:id", async (req, res) => {
	var message = "";
	if (isNaN(req.body.Stu_Phone) || req.body.Stu_Phone.length != 11) {
	message = "Please enter a valid phone number";
	} else {
	await connection.query("UPDATE Student SET ? WHERE URN = ?", [
	req.body,
	req.params.id,
	]);
	message = "Student updated";
	}
	const student = await connection.query(
	"SELECT * FROM Student WHERE URN = ?",
	[req.params.id]
	);
	const courses = await connection.query("SELECT * FROM Course");
	res.render("student_edit", {
	student: student[0],
	courses: courses,
	message: message,
	});
});

app.get("/societies/committeemem/:id", async (req, res) => {
	  const committeeMember = await connection.query(
	"SELECT * FROM Committee_Member WHERE Soc_ID = ?",
	[req.params.id]
	  );
	  const committeeEmail = await connection.query(
		"SELECT * FROM Committee_Email WHERE Committee_name IN (SELECT Committee_name FROM Committee_Member WHERE Soc_ID = ?)",
		[req.params.id]
	  );
	  res.render("committeemem", {
		committeeMember: committeeMember,
		committeeEmail: committeeEmail,
	  });
  });
  


app.listen(PORT, () => {
	console.log(`Example app listening at http://localhost:${PORT}`);
});

app.post("/students/edit/:id", async (req, res) => {
console.log(req.body);
});
