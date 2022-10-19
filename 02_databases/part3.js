use uni
db.createCollection('students');

show dbs;
show collections;

db.students.insertMany([
  { first_name: "Ivan", last_name: "Ivanov", birthday: new Date("1999-01-02"), entranceYear: 2021 },
  { first_name: "Petro", last_name: "Petrov", birthday: new Date("1989-03-10"), entranceYear: 2020 },
  { first_name: "John", last_name: "Smith", entranceYear: 2021 },
]);

db.students.find({ entranceYear: 2021 }).pretty();
