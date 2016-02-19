use omoto;
drop table customer_timeout;
create table customer_timeout(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20),
	email VARCHAR(30),
	time_out DATETIME
);

DELIMITER &&

DROP PROCEDURE IF EXISTS fill_customer_timeout&&
create procedure fill_customer_timeout()
 begin 
   declare x int;
    set x:=1;
	SET @MIN = '2016-01-01 00:00:00';
	SET @MAX = '2016-02-29 23:59:59';
	truncate table customer_timeout;
	while(x<1000) DO
		SET @timeout=(SELECT TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN));
		insert into customer_timeout(name,email,time_out) values(concat('name',cast(x as char(4))),concat('name',cast(x as char(4)),'@gmail.com'),@timeout);
		set x := x + 1;
	end while;
end&&
DELIMITER

call fill_customer_timeout;

select * from customer_timeout;
