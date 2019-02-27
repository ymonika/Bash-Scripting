
#dbHost dbName dbUserName dbpassword noOfDays maxNoOfDays
deltaDays=$5
maxDeltaDays=$6
dataset_date=`date`
queryDelimiter="'"
deltaDate=$queryDelimiter$(date -d "$date -$deltaDays days" +"%Y-%m-%d")$queryDelimiter
maxDeltaDate=$queryDelimiter$(date -d "$date -$maxDeltaDays days" +"%Y-%m-%d")$queryDelimiter
echo "Max Delta Days date: "$maxDeltaDate
echo "Delta Days date: "$deltaDate 

localhost=$1
db=$2
user=$3
pass=$4
mysql -h "$localhost"  -u "$user" -p"$pass" "$db" <<EOF

/*Part-1 Delete Count */
SELECT count(c.portalId) as InActive_Customer
 FROM Customer c WHERE c.lastModifyDate < $deltaDate
 AND c.isESMECustomer = FALSE  
 AND c.migratedPAYGCustomer = FALSE  
 AND c.portalId not in (select distinct a.portalId from Msisdn a where a.status = 'ACTIVE' or (a.status = 'INACTIVE' and (a.disconnectionDate > $deltaDate))) 
 AND c.portalId in (select distinct a.portalId from Msisdn a where a.status = 'INACTIVE' and (a.disconnectionDate < $deltaDate  AND a.disconnectionDate >= $maxDeltaDate  OR a.disconnectionDate is null));


/* INACTIVE Companion */
Select count(*) as INACTIVE_Companion  from Msisdn m   
   where m.status = 'INACTIVE'   
   And m.productType = 'PAYM-DEPENDANT'   
   And ((m.disconnectionDate < $deltaDate AND m.disconnectionDate >= $maxDeltaDate ) or m.disconnectionDate is null);

/* INACTIVE Lead */
Select count(*) as INACTIVE_Lead from Msisdn m where m.status = 'INACTIVE' 
 And productType != 'PAYM-DEPENDANT' 
 And ((m.disconnectionDate < $deltaDate AND m.disconnectionDate >= $maxDeltaDate ) or m.disconnectionDate is null) 
 And ( id not in (Select distinct leadMsisdnId from Companion) 
 OR id in ( Select distinct leadMsisdnId from Companion c 
 where c.status = 'INACTIVE' 
 And ((c.disconnectionDate < $deltaDate AND c.disconnectionDate >= $maxDeltaDate) or c.disconnectionDate is null)  
 ) );

/* Customers with No Msisdns */
SELECT count(*) as Customer_With_No_Msisdns
FROM Customer c WHERE c.lastModifyDate < $deltaDate
AND c.isESMECustomer = 0 
AND c.migratedPAYGCustomer = 0
AND c.portalId not in (select distinct a.portalId from Msisdn a);

EOF
