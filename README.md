# LansweeperReporting

Lansweeper (https://www-lansweeper.com) is an application that gathers hardware and software information of computers and other devices on a computer network for management and compliance and audit purposes. The application also encompasses a ticket based help desk system and capabilities for software updates on target devices.

The problem I have encountered is that when you use Lansweeper in a service company that has to manage the IT assets of different companies it becomes complicated to maintain 
reports without having to edit or modify them frequently.

This is why I created a powershell script that was much easier to maintain at the query level. This script exported the data of my queries directly into a .csv file 
that I could send to anyone.

## Configuration 

He entire configuration is done in the configuration file 
"MyScriptPath\Config\config.xml"

## Variables in config.xml

### Debug settings
- Enable or Disable debug output ( 1 Enable / 0 = Disable )
    - key="debug"           

### SQL settings
- SQL server name
    - Key="sqlserver"
- SQL DB name
    - Key="sqlDB"
- SQL user name
    - Key="sqlUser"
- SQL password
    - Key="sqlPassword"

### Reporting settings
- Report name
    - Key="reportName"

### Email Settings
- Enable or disable sending the report by email ( 1 Enable / 0 = Disable )
    - Key="emailSend"       
- Email to
    - Key="emailTo"
- Email from
    - Key="emailFrom"
- Email subject
    - Key="emailSubject"
- Email body
    - Key="emailBody"
- Email server
    - Key="emailServ"
- Email port
    - Key="emailPort"