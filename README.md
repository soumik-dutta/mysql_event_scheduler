
# Mysql Event Scheduler

Creating Mysql Scheduler monitor changes in a table and notify Java server.

Things required 
  - Installing lib_mysqludf_sys UDF funtion Mysql
  - Creating Event and Schedule it at an interval
  - create a procedure that will be called by the scheduler and it will intern call the Java Engine.


>The aim of this project is to notify the 
>Java engine that there are some users that
>should be notified by email/any other means 
>when the theshold time that is allocated to 
>them is over.


### Installing UDF in Mysql
>Here we are installing [lib_mysqludf_sys][df1] that will basically enable to communicate with the OS in this case 
>Ubuntu.

### Installation

Download the repos from [lib_mysqludf_sys][df1]:

```sh
$ ls
install.sh          lib_mysqludf_sys.html  lib_mysqludf_sys.sql  
lib_mysqludf_sys.c  lib_mysqludf_sys.so    Makefile
```
```sh
$ make install
```
##### If the installation shows error like cannot acess share files then change the Makefile accordingly


```sh
LIBDIR=/usr/lib/mysql/plugin

install:
	gcc -DMYSQL_DYNAMIC_PLUGIN -fPIC -Wall -I/usr/include/mysql -I. -shared lib_mysqludf_sys.c -o $(LIBDIR)/lib_mysqludf_sys.so
```
The plugin directory will be found using the following commend inside Mysql.

```sh
mysql> SHOW VARIABLES LIKE 'plugin_dir';
```
To know more [plugin dir in mysql][link1]

##### Lets create the function that will communicate with the operating system .
```sql
CREATE FUNCTION sys_eval RETURNS INT SONAME ‘lib_mysqludf_sys.so';
```
### For Ubuntu
Also check the Application Armor protection
```sh
$ sudo aa-status
apparmor module is loaded.
20 profiles are loaded.
20 profiles are in enforce mode.
   /sbin/dhclient
   /usr/bin/evince
   /usr/bin/evince-previewer
   /usr/bin/evince-previewer//sanitized_helper
   /usr/bin/evince-thumbnailer
   /usr/bin/evince-thumbnailer//sanitized_helper
   /usr/bin/evince//sanitized_helper
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/cups/backend/cups-pdf
   /usr/lib/lightdm/lightdm-guest-session
   /usr/lib/lightdm/lightdm-guest-session//chromium
   /usr/lib/telepathy/mission-control-5
   /usr/lib/telepathy/telepathy-*
   /usr/lib/telepathy/telepathy-*//pxgsettings
   /usr/lib/telepathy/telepathy-*//sanitized_helper
   /usr/lib/telepathy/telepathy-ofono
   /usr/sbin/cups-browsed
   /usr/sbin/cupsd
   /usr/sbin/tcpdump
0 profiles are in complain mode.
4 processes have profiles defined.
4 processes are in enforce mode.
   /sbin/dhclient (1081) 
   /usr/lib/telepathy/mission-control-5 (2221) 
   /usr/sbin/cups-browsed (973) 
   /usr/sbin/cupsd (2245) 
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.
```
see whether msqld is having an enforcement from the OS if yes then disable it.

```sh
sudo ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld
```
Details refer: [apparmor link][link2]

### For CentOS
If  `Curl` command doesn't have permission then change the `SElinux` variable in the `/etc/selinux/config` file.
```sh
sudo vi /etc/selinux/config
SELINUX=disabled
```
Then reboot your system
Details refer: [SElinux link][link3]

### Mysql Event

Please enable/disable the event_scheduler in Mysql

```sql
SET GLOBAL event_scheduler = ON;
SET GLOBAL event_scheduler = OFF;
```

Then start CREATING.EVENT.sql

>The Event can be schedulable to a time interval 
>and will call a procedure `notify_user_by_email()`.
>This will intern call the Application server URL/URI
>where the listener for this event is resided.



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [df1]: <https://github.com/mysqludf/lib_mysqludf_sys>

   [link1]: <http://stackoverflow.com/questions/28642274/error-1126-hy000-cant-open-shared-library-lib-mysqludf-sys-so-errno-193>
   [link2]:<http://www.cyberciti.biz/faq/ubuntu-linux-howto-disable-apparmor-commands/>
   [link3]:<http://www.akashif.co.uk/php/curl-error-7-failed-to-connect-to-permission-denied/>


© 2016 GitHub, Inc. Terms Privacy Security Contact Help
