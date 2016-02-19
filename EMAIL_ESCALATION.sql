
-- creating Event that will work as a sheduler.
DROP event excalation_event;
CREATE EVENT
IF NOT EXISTS excalation_event 
ON SCHEDULE every 5 SECOND 
do call notify_user_by_email();


-- procedure that will be called by the event
DELIMITER $$

DROP PROCEDURE

IF EXISTS notify_user_by_email$$
	CREATE PROCEDURE notify_user_by_email ()

BEGIN
	DROP TABLE email_notification;

	CREATE TABLE email_notification AS (SELECT * FROM customer_timeout WHERE time_out < NOW());

	SET

	@count = (
			SELECT count(*)
			FROM email_notification
			);
	
	IF @count > 0 then
		SET @result = sys_eval('curl http://localhost:8081/omoto/mysqlEvent.htm');
END

IF ;END $$
DELIMITER

use omoto;

-- change mysql settings for our event to WORK
SET GLOBAL event_scheduler = ON;
SET GLOBAL event_scheduler = OFF;

