DELIMITER $$

DROP PROCEDURE IF EXISTS debug_msg$$
DROP PROCEDURE IF EXISTS sessionActivity$$

CREATE PROCEDURE debug_msg(enabled INTEGER, msg VARCHAR(255))
BEGIN
  IF enabled THEN BEGIN
    select concat("** ", msg) AS '** DEBUG:';
  END; END IF;
END $$

CREATE PROCEDURE sessionActivity(id BIGINT)
BEGIN
  IF id THEN BEGIN
   DECLARE cmd CHAR(255);
   DECLARE result CHAR(255);
   SET cmd = 'cp /home/omoto/Desktop/Issues.png /home/omoto';
   SET result = sys_exec(cmd);
   select result;
   #####SET result = sys_exec(cmd);
   call debug_msg(TRUE,cmd);
   #####call debug_msg(TRUE,result);
  END; END IF;
END$$

DELIMITER ;



CALL sessionActivity(1);