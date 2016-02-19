
drop event if EXISTS excalation_event;

create EVENT if not EXISTS excalation_event
ON SCHEDULE EVERY 5 MINUTE
STARTS CURRENT_TIMESTAMP
	do 
      call notify_user_by_email();


CREATE TABLE email_notification LIKE customer_timeout; 


DELIMITER $$
	DROP PROCEDURE IF EXISTS notify_user_by_email$$
	CREATE PROCEDURE notify_user_by_email()
	BEGIN	
		truncate table email_notification;
		INSERT INTO email_notification select * from customer_timeout where time_out<NOW();
		set @count:=(select count(*) from email_notification);
		if @count>0 then 
			set @result=sys_exec('firefox http://omoto.io');
		end if;
END $$
DELIMITER
		
	
SET GLOBAL event_scheduler = ON;
show errors;
show WARNINGS;


call notify_user_by_email();

show PROCESSLIST;


 SELECT sys_exec('wget http://omoto.io') as sys_exec;


select * from email_notification;