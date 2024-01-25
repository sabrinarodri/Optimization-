/* -------------------------------------------------------------
Purpose: To create the Nasdaq schema and to house correlation, 
			meanReturn, and Expected Profitability tables
Created: 12/06/2022
Edit   : 12/07/2022
------------------------------------------------------------- */

-- create schema nasdaq; -- schema already created; do not rerun
use nasdaq; 

-- if rerunning this file, redrop tables to not create duplicates
drop table corr;
drop table cov; 
drop table r;
drop table portfolio;

-- Create the Correlation table 
create table corr(
	stock1 varchar(5),
    stock2 varchar(5),
    cor double,
    primary key(stock1,stock2)
);
-- Insert Example; Do Not insert into actual data
-- insert into corr (stock1,stock2,cor)
-- 	values ('asdf1','asdf2','0.05');

-- Create the Covariance table 
create table cov (
stock1 varchar(10),
stock2 varchar(10),
covariance double
);

-- Create the mean return table
create table r (
stock varchar(10),
meanReturn double,
SD double
);

-- Create the Portfolio table for Expected Return and Expected Risk
create table portfolio (
expReturn double,
expRisk double
);