-- create database
create database SkyHighAirlines;
use SkyHighAirlines;

-- 1. airport table (independent)
create table Airport (
    AirportCode char(3) primary key,
    AirportName varchar(100) not null,
    City varchar(50) not null,
    Country varchar(50) not null
);

-- 2. aircraft table (independent)
create table Aircraft (
    AircraftID int primary key,
    Model varchar(50) not null,
    Manufacturer varchar(50),
    TotalCapacity int not null
);

-- 3. passenger table (independent)
create table Passenger (
    PassengerID int primary key,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    PassportNo varchar(20) unique not null,
    Email varchar(100) unique,
    Phone varchar(20),
    Address varchar(255)
);

-- 4. crew_member table (independent)
create table Crew_Member (
    CrewID int primary key,
    FullName varchar(100) not null,
    Role varchar(50) not null,
    LicenseNumber varchar(50) unique not null,
    YearsOfExperience int
);

-- 5. flight table (depends on airport & aircraft)
create table Flight (
    FlightID int primary key,
    FlightNumber varchar(10) not null,
    Source_AirportCode char(3) not null,
    Dest_AirportCode char(3) not null,
    AircraftID int not null,
    DepartureTime datetime not null,
    ArrivalTime datetime not null,
    Status varchar(20),
    foreign key (Source_AirportCode) references Airport(AirportCode),
    foreign key (Dest_AirportCode) references Airport(AirportCode),
    foreign key (AircraftID) references Aircraft(AircraftID)
);

-- 6. seat table (depends on aircraft)
create table Seat (
    SeatID int primary key,
    AircraftID int not null,
    SeatNumber varchar(10) not null,
    ClassType varchar(20) not null,
    foreign key (AircraftID) references Aircraft(AircraftID)
);

-- 7. booking table (depends on passenger)
create table Booking (
    BookingID int primary key,
    PassengerID int not null,
    BookingDate datetime,
    BookingStatus varchar(20),
    TotalAmount decimal(10, 2),
    foreign key (PassengerID) references Passenger(PassengerID)
);

-- 8. ticket table (links booking, flight, seat)
create table Ticket (
    TicketID int primary key,
    BookingID int not null,
    FlightID int not null,
    SeatID int not null,
    TicketPrice decimal(10, 2) not null,
    foreign key (BookingID) references Booking(BookingID),
    foreign key (FlightID) references Flight(FlightID),
    foreign key (SeatID) references Seat(SeatID)
);

-- 9. payment table (depends on booking)
create table Payment (
    PaymentID int primary key,
    BookingID int unique not null,
    PaymentDate datetime,
    PaymentMethod varchar(50),
    Amount decimal(10, 2) not null,
    foreign key (BookingID) references Booking(BookingID)
);

-- 10. baggage table (depends on ticket)
create table Baggage (
    BaggageID int primary key,
    TicketID int not null,
    WeightKg decimal(5, 2),
    Type varchar(20),
    foreign key (TicketID) references Ticket(TicketID)
);

-- 11. flight_roster (bridge table for flight <-> crew many-to-many)
create table Flight_Roster (
    RosterID int primary key,
    FlightID int not null,
    CrewID int not null,
    foreign key (FlightID) references Flight(FlightID),
    foreign key (CrewID) references Crew_Member(CrewID)
);

-- 1. insert airports
insert into Airport (AirportCode, AirportName, City, Country) values
    ('LHE', 'Allama Iqbal International', 'Lahore', 'Pakistan'),
    ('KHI', 'Jinnah International', 'Karachi', 'Pakistan'),
    ('ISB', 'Islamabad International', 'Islamabad', 'Pakistan'),
    ('DXB', 'Dubai International', 'Dubai', 'UAE'),
    ('LHR', 'Heathrow Airport', 'London', 'UK'),
    ('JFK', 'John F. Kennedy', 'New York', 'USA'),
    ('HND', 'Haneda Airport', 'Tokyo', 'Japan'),
    ('CDG', 'Charles de Gaulle', 'Paris', 'France'),
    ('SIN', 'Changi Airport', 'Singapore', 'Singapore'),
    ('YYZ', 'Pearson International', 'Toronto', 'Canada');

-- 2. insert aircraft
insert into Aircraft (AircraftID, Model, Manufacturer, TotalCapacity) values
    (1, 'Boeing 777', 'Boeing', 300),
    (2, 'Airbus A320', 'Airbus', 150),
    (3, 'Boeing 737', 'Boeing', 180),
    (4, 'Airbus A380', 'Airbus', 500),
    (5, 'Boeing 787', 'Boeing', 250),
    (6, 'ATR 72', 'ATR', 70),
    (7, 'Airbus A350', 'Airbus', 300),
    (8, 'Boeing 747', 'Boeing', 400),
    (9, 'Embraer E190', 'Embraer', 100),
    (10, 'Bombardier CRJ', 'Bombardier', 80);

-- 3. insert seats
insert into Seat (SeatID, SeatNumber, ClassType, AircraftID) values
    (1, '1A', 'Business', 1),
    (2, '1B', 'Business', 1),
    (3, '10A', 'Economy', 1),
    (4, '10B', 'Economy', 1),
    (5, '12A', 'Economy', 1),
    (6, '1A', 'Business', 2),
    (7, '1B', 'Business', 2),
    (8, '5A', 'Economy', 2),
    (9, '5B', 'Economy', 2),
    (10, '6A', 'Economy', 2);

-- 4. insert passengers
insert into Passenger (PassengerID, FirstName, LastName, PassportNo, Email, Phone, Address) values
    (1, 'Ali', 'Khan', 'PK123456', 'ali@gmail.com', '03001234567', 'Lahore, PK'),
    (2, 'Sara', 'Ahmed', 'PK654321', 'sara@yahoo.com', '03217654321', 'Karachi, PK'),
    (3, 'John', 'Doe', 'US987654', 'john@gmail.com', '+14155552671', 'New York, USA'),
    (4, 'Ayesha', 'Malik', 'PK112233', 'ayesha@hotmail.com', '03334455667', 'Islamabad, PK'),
    (5, 'Zara', 'Noor', 'PK998877', 'zara@gmail.com', '03456677889', 'Lahore, PK'),
    (6, 'David', 'Smith', 'UK554433', 'david@outlook.com', '+4420794601', 'London, UK'),
    (7, 'Hiro', 'Tanaka', 'JP223344', 'hiro@jp.com', '+8190123456', 'Tokyo, JP'),
    (8, 'Maria', 'Garcia', 'ES778899', 'maria@gmail.com', '+3461234578', 'Madrid, ES'),
    (9, 'Bilal', 'Sheikh', 'PK445566', 'bilal@live.com', '03125556667', 'Multan, PK'),
    (10, 'Fatima', 'Bibi', 'PK776655', 'fatima@gmail.com', '03018889990', 'Peshawar, PK');

-- 5. insert crew members
insert into Crew_Member (CrewID, FullName, Role, LicenseNumber, YearsOfExperience) values
    (1, 'Capt. Ahmed', 'Pilot', 'LIC-001', 15),
    (2, 'Capt. Sarah', 'Pilot', 'LIC-002', 12),
    (3, 'Officer Mike', 'Co-Pilot', 'LIC-003', 8),
    (4, 'Officer Hina', 'Co-Pilot', 'LIC-004', 7),
    (5, 'Emily Rose', 'Attendant', 'LIC-005', 4),
    (6, 'Jack Dawson', 'Attendant', 'LIC-006', 5),
    (7, 'Rose DeWitt', 'Attendant', 'LIC-007', 3),
    (8, 'Usman Ghani', 'Attendant', 'LIC-008', 6),
    (9, 'Sana Mir', 'Attendant', 'LIC-009', 2),
    (10, 'Tom Holland', 'Attendant', 'LIC-010', 4);

-- 6. insert flights
insert into Flight (FlightID, FlightNumber, Source_AirportCode, Dest_AirportCode, AircraftID, DepartureTime, ArrivalTime, Status) values
    (1, 'SK-101', 'LHE', 'DXB', 1, '2026-02-01 08:00:00', '2026-02-01 11:00:00', 'Scheduled'),
    (2, 'SK-102', 'DXB', 'LHE', 1, '2026-02-02 14:00:00', '2026-02-02 17:00:00', 'Scheduled'),
    (3, 'SK-201', 'KHI', 'LHR', 2, '2026-02-05 06:00:00', '2026-02-05 14:00:00', 'Delayed'),
    (4, 'SK-301', 'ISB', 'JFK', 3, '2026-02-10 09:00:00', '2026-02-10 21:00:00', 'Scheduled'),
    (5, 'SK-401', 'LHE', 'KHI', 4, '2026-02-12 10:00:00', '2026-02-12 12:00:00', 'Completed'),
    (6, 'SK-501', 'HND', 'SIN', 5, '2026-02-15 18:00:00', '2026-02-16 01:00:00', 'Scheduled'),
    (7, 'SK-601', 'CDG', 'DXB', 6, '2026-02-18 07:30:00', '2026-02-18 13:00:00', 'Cancelled'),
    (8, 'SK-701', 'YYZ', 'LHR', 7, '2026-02-20 15:00:00', '2026-02-20 22:00:00', 'Scheduled'),
    (9, 'SK-103', 'LHE', 'ISB', 2, '2026-02-22 08:00:00', '2026-02-22 09:00:00', 'Scheduled'),
    (10, 'SK-104', 'KHI', 'DXB', 1, '2026-02-25 11:00:00', '2026-02-25 13:30:00', 'Scheduled');

-- 7. insert flight roster
insert into Flight_Roster (RosterID, FlightID, CrewID) values
    (1, 1, 1),
    (2, 1, 3),
    (3, 1, 5),
    (4, 1, 6),
    (5, 2, 2),
    (6, 2, 4),
    (7, 2, 7),
    (8, 3, 1),
    (9, 3, 5),
    (10, 4, 2);

-- 8. insert bookings
insert into Booking (BookingID, PassengerID, BookingDate, BookingStatus, TotalAmount) values
    (1, 1, '2026-01-15', 'Confirmed', 1500.00),
    (2, 2, '2026-01-16', 'Confirmed', 2000.00),
    (3, 3, '2026-01-17', 'Pending', 5000.00),
    (4, 4, '2026-01-18', 'Confirmed', 1200.00),
    (5, 5, '2026-01-18', 'Cancelled', 1500.00),
    (6, 6, '2026-01-19', 'Confirmed', 3000.00),
    (7, 7, '2026-01-19', 'Confirmed', 4500.00),
    (8, 8, '2026-01-20', 'Confirmed', 2500.00),
    (9, 9, '2026-01-20', 'Confirmed', 1000.00),
    (10, 10, '2026-01-21', 'Pending', 1800.00);

-- 9. insert payments
insert into Payment (PaymentID, BookingID, PaymentDate, PaymentMethod, Amount) values
    (1, 1, '2026-01-15', 'Credit Card', 1500.00),
    (2, 2, '2026-01-16', 'Cash', 2000.00),
    (3, 3, '2026-01-17', 'Credit Card', 5000.00),
    (4, 4, '2026-01-18', 'Bank Transfer', 1200.00),
    (5, 6, '2026-01-19', 'Credit Card', 3000.00),
    (6, 7, '2026-01-19', 'Credit Card', 4500.00),
    (7, 8, '2026-01-20', 'Cash', 2500.00),
    (8, 9, '2026-01-20', 'Bank Transfer', 1000.00),
    (9, 10, '2026-01-21', 'Credit Card', 1800.00),
    (10, 5, '2026-01-18', 'Refunded', 0.00);

-- 10. insert tickets
insert into Ticket (TicketID, TicketPrice, BookingID, SeatID, FlightID) values
    (1, 1500.00, 1, 1, 1),
    (2, 2000.00, 2, 2, 1),
    (3, 5000.00, 3, 3, 4),
    (4, 1200.00, 4, 4, 1),
    (5, 1500.00, 5, 5, 1),
    (6, 3000.00, 6, 6, 3),
    (7, 4500.00, 7, 7, 3),
    (8, 2500.00, 8, 8, 2),
    (9, 1000.00, 9, 9, 2),
    (10, 1800.00, 10, 10, 2);

-- 11. insert baggage
insert into Baggage (BaggageID, WeightKg, Type, TicketID) values
    (1, 20.5, 'Checked', 1),
    (2, 15.0, 'Checked', 2),
    (3, 7.0, 'Carry-on', 3),
    (4, 22.0, 'Checked', 4),
    (5, 5.0, 'Carry-on', 5),
    (6, 25.0, 'Checked', 6),
    (7, 8.0, 'Carry-on', 7),
    (8, 18.0, 'Checked', 8),
    (9, 12.0, 'Checked', 9),
    (10, 30.0, 'Checked', 10);

-- query 1: list all passengers who have booked 'business' class tickets on 'boeing 777' aircraft.
-- tables: passenger, booking, ticket, seat, aircraft (5 tables)
select distinct p.FirstName, p.LastName, a.Model, s.ClassType
from Passenger p
    join Booking b on p.PassengerID = b.PassengerID
    join Ticket t on b.BookingID = t.BookingID
    join Seat s on t.SeatID = s.SeatID
    join Aircraft a on s.AircraftID = a.AircraftID
where s.ClassType = 'Business' and a.Model = 'Boeing 777';

-- query 2: find the total baggage weight for each passenger on flights departing from 'lahore'.
-- tables: passenger, booking, ticket, flight, airport, baggage (6 tables)
select p.FirstName, p.LastName, sum(bg.WeightKg) as TotalWeight
from Passenger p
    join Booking b on p.PassengerID = b.PassengerID
    join Ticket t on b.BookingID = t.BookingID
    join Baggage bg on t.TicketID = bg.TicketID
    join Flight f on t.FlightID = f.FlightID
    join Airport ap on f.Source_AirportCode = ap.AirportCode
where ap.City = 'Lahore'
group by p.PassengerID;

-- query 3: show details of payments made for flights scheduled to land in 'dubai'.
-- tables: payment, booking, ticket, flight, airport (5 tables)
select pm.PaymentID, pm.Amount, f.FlightNumber, ap.City as Destination
from Payment pm
    join Booking b on pm.BookingID = b.BookingID
    join Ticket t on b.BookingID = t.BookingID
    join Flight f on t.FlightID = f.FlightID
    join Airport ap on f.Dest_AirportCode = ap.AirportCode
where ap.City = 'Dubai';

-- query 4: list crew members who are assigned to flights operated by 'airbus a320'.
-- tables: crew_member, flight_roster, flight, aircraft (4 tables)
select distinct c.FullName, c.Role, a.Model
from Crew_Member c
    join Flight_Roster fr on c.CrewID = fr.CrewID
    join Flight f on fr.FlightID = f.FlightID
    join Aircraft a on f.AircraftID = a.AircraftID
where a.Model = 'Airbus A320';

-- query 5: find passengers who have made a payment of more than 2000 using 'credit card'.
-- tables: passenger, booking, payment, ticket (4 tables)
select p.FirstName, p.LastName, pm.Amount, pm.PaymentMethod
from Passenger p
    join Booking b on p.PassengerID = b.PassengerID
    join Payment pm on b.BookingID = pm.BookingID
    join Ticket t on b.BookingID = t.BookingID
where pm.Amount > 2000 and pm.PaymentMethod = 'Credit Card';

-- query 6: list all flights, the aircraft model, and the number of bags checked in for that flight.
-- tables: flight, aircraft, ticket, baggage (4 tables)
select f.FlightNumber, a.Model, count(bg.BaggageID) as TotalBags
from Flight f
    join Aircraft a on f.AircraftID = a.AircraftID
    left join Ticket t on f.FlightID = t.FlightID
    left join Baggage bg on t.TicketID = bg.TicketID
group by f.FlightID, a.Model;

-- query 7: show the seat number and class for passengers traveling to 'london' (LHR).
-- tables: passenger, booking, ticket, seat, flight, airport (6 tables)
select p.FirstName, s.SeatNumber, s.ClassType, ap.AirportName
from Passenger p
    join Booking b on p.PassengerID = b.PassengerID
    join Ticket t on b.BookingID = t.BookingID
    join Seat s on t.SeatID = s.SeatID
    join Flight f on t.FlightID = f.FlightID
    join Airport ap on f.Dest_AirportCode = ap.AirportCode
where ap.AirportCode = 'LHR';

-- query 8: find the email addresses of passengers whose flights have been 'cancelled'.
-- tables: passenger, booking, ticket, flight (4 tables)
select distinct p.Email, f.Status
from Passenger p
    join Booking b on p.PassengerID = b.PassengerID
    join Ticket t on b.BookingID = t.BookingID
    join Flight f on t.FlightID = f.FlightID
where f.Status = 'Cancelled';

-- query 9: get the total revenue generated from 'economy' class seats on all flights.
-- tables: payment, booking, ticket, seat (4 tables)
select sum(pm.Amount) as TotalEconomyRevenue
from Payment pm
    join Booking b on pm.BookingID = b.BookingID
    join Ticket t on b.BookingID = t.BookingID
    join Seat s on t.SeatID = s.SeatID
where s.ClassType = 'Economy';

-- query 10: list pilots (role = 'pilot') who have flown flights departing from 'karachi'.
-- tables: crew_member, flight_roster, flight, airport (4 tables)
select distinct c.FullName, ap.City as DepartureCity
from Crew_Member c
    join Flight_Roster fr on c.CrewID = fr.CrewID
    join Flight f on fr.FlightID = f.FlightID
    join Airport ap on f.Source_AirportCode = ap.AirportCode
where c.Role = 'Pilot' and ap.City = 'Karachi';

-- query 11: show booking details for passengers who have 'checked' baggage heavier than 20kg.
-- tables: booking, ticket, baggage, passenger (4 tables)
select b.BookingID, p.FirstName, bg.WeightKg, bg.Type
from Booking b
    join Passenger p on b.PassengerID = p.PassengerID
    join Ticket t on b.BookingID = t.BookingID
    join Baggage bg on t.TicketID = bg.TicketID
where bg.Type = 'Checked' and bg.WeightKg > 20;

-- query 12: find destination airports that have received flights carrying 'business' class passengers.
-- tables: airport, flight, ticket, seat (4 tables)
select distinct ap.AirportName, ap.City
from Airport ap
    join Flight f on ap.AirportCode = f.Dest_AirportCode
    join Ticket t on f.FlightID = t.FlightID
    join Seat s on t.SeatID = s.SeatID
where s.ClassType = 'Business';

-- query 13: find passengers who have paid more than the average payment amount of all bookings.
-- tables involved: passenger, booking, payment (nested logic covers 3, but implies complex data relation)
-- extending to 4: filtering by flights from a specific airline manufacturer in subquery.
select FirstName, LastName
from Passenger
where PassengerID in (
    select b.PassengerID
    from Booking b
        join Payment p on b.BookingID = p.BookingID
    where p.Amount > (select avg(Amount) from Payment)
);

-- query 14: list flights that have no passengers assigned to them yet (using not exists).
-- tables: flight, ticket, booking, passenger
select FlightNumber, Status
from Flight f
where not exists (
    select 1
    from Ticket t
        join Booking b on t.BookingID = b.BookingID
    where t.FlightID = f.FlightID
);

-- query 15: find the aircraft model used for the flight with the highest ticket price.
-- tables: aircraft, flight, ticket, booking
select Model
from Aircraft
where AircraftID = (
    select AircraftID
    from Flight
    where FlightID = (
        select FlightID
        from Ticket
        order by TicketPrice desc
        limit 1
    )
);

-- query 16: find passengers who have booked a flight to 'london' but have not made a payment yet (or payment is 0/pending logic).
-- tables: passenger, booking, ticket, flight, airport
select FirstName, LastName
from Passenger
where PassengerID in (
    select b.PassengerID
    from Booking b
        join Ticket t on b.BookingID = t.BookingID
        join Flight f on t.FlightID = f.FlightID
    where f.Dest_AirportCode = (select AirportCode from Airport where City = 'London')
      and b.BookingID not in (select BookingID from Payment)
);

-- query 17: list crew members who have never been assigned to a flight using a 'boeing 777'.
-- tables: crew_member, flight_roster, flight, aircraft
select FullName
from Crew_Member
where CrewID not in (
    select fr.CrewID
    from Flight_Roster fr
        join Flight f on fr.FlightID = f.FlightID
        join Aircraft a on f.AircraftID = a.AircraftID
    where a.Model = 'Boeing 777'
);

-- query 18: find the passenger who brought the heaviest bag on a flight departing from 'islamabad'.
-- tables: passenger, booking, ticket, baggage, flight, airport
select FirstName, LastName
from Passenger
where PassengerID = (
    select b.PassengerID
    from Booking b
        join Ticket t on b.BookingID = t.BookingID
        join Baggage bg on t.TicketID = bg.TicketID
        join Flight f on t.FlightID = f.FlightID
    where f.Source_AirportCode = (select AirportCode from Airport where City = 'Islamabad')
    order by bg.WeightKg desc
    limit 1
);

-- query 19: list airports that are destinations for flights piloted by 'capt. ahmed'.
-- tables: airport, flight, flight_roster, crew_member
select AirportName
from Airport
where AirportCode in (
    select Dest_AirportCode
    from Flight f
    where f.FlightID in (
        select fr.FlightID
        from Flight_Roster fr
            join Crew_Member c on fr.CrewID = c.CrewID
        where c.FullName = 'Capt. Ahmed'
    )
);

-- query 20: find the total number of seats available on aircraft manufactured by 'airbus'.
-- tables: seat, aircraft (logic requires 4? let's make it complex: only count seats that have been booked at least once)
select count(*) as AirbusSeatsBooked
from Seat
where AircraftID in (select AircraftID from Aircraft where Manufacturer = 'Airbus')
  and SeatID in (
    select t.SeatID
    from Ticket t
        join Booking b on t.BookingID = b.BookingID
);

-- query 21: show passengers who have bookings on the same date as 'ali khan'.
-- tables: passenger, booking, ticket, flight
select FirstName, LastName
from Passenger
where PassengerID != (select PassengerID from Passenger where FirstName = 'Ali' and LastName = 'Khan')
  and PassengerID in (
    select b.PassengerID
    from Booking b
    where date(b.BookingDate) = (
        select date(b2.BookingDate)
        from Booking b2
            join Passenger p2 on b2.PassengerID = p2.PassengerID
        where p2.FirstName = 'Ali' and p2.LastName = 'Khan'
        limit 1
    )
);

-- query 22: find flights that have a higher capacity than the average capacity of all aircraft.
-- tables: flight, aircraft, ticket, seat
select FlightNumber
from Flight f
where f.AircraftID in (
    select AircraftID
    from Aircraft
    where TotalCapacity > (select avg(TotalCapacity) from Aircraft)
);

-- query 23: list passengers who traveled in 'business' class but paid less than the average economy price (deal seekers).
-- tables: passenger, booking, ticket, seat, payment
select p.FirstName, p.LastName
from Passenger p
where p.PassengerID in (
    select b.PassengerID
    from Booking b
        join Ticket t on b.BookingID = t.BookingID
        join Seat s on t.SeatID = s.SeatID
    where s.ClassType = 'Business'
      and t.TicketPrice < (
        select avg(t2.TicketPrice)
        from Ticket t2
            join Seat s2 on t2.SeatID = s2.SeatID
        where s2.ClassType = 'Economy'
    )
);

-- query 24: find the airport with the most departures recorded in the system.
-- tables: airport, flight, ticket, booking
select AirportName
from Airport
where AirportCode = (
    select Source_AirportCode
    from Flight
    group by Source_AirportCode
    order by count(*) desc
    limit 1
);