
drop event if EXISTS excalation_event;

--creating a scheduler at an interval of 5mins
create EVENT if not EXISTS excalation_event
ON SCHEDULE EVERY 5 MINUTE
STARTS CURRENT_TIMESTAMP
	do 
      call notify_user_by_email();


CREATE TABLE email_notification LIKE customer_timeout; 

-- procedure this is called by the scheduler
DELIMITER $$
	DROP PROCEDURE IF EXISTS notify_user_by_email$$
	CREATE PROCEDURE notify_user_by_email()
	BEGIN	
		truncate table email_notification;
		INSERT INTO email_notification select * from customer_timeout where time_out<NOW();
		set @count:=(select count(*) from email_notification);
		if @count>0 then 
			set @result=sys_eval('curl your_listening server');
		end if;
END $$
DELIMITER
		
-- switch on the event_schedular	
SET GLOBAL event_scheduler = ON;
SET GLOBAL event_scheduler = OFF;

show errors;
show WARNINGS;

-- testing the procedure
call notify_user_by_email();

--  see the process list whether sheduler is running
show PROCESSLIST;

-- testing sys_eval function
SELECT sys_eval('wget http://omoto.io') as sys_exec;


