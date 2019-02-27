#sh Bss-Sh-Script.sh leancrm root root 10 localhost

delimiter='_'
strDateAndSeq=$(date -d 'now' '+%Y%m%d')$delimiter$4
consumerFile=DM_R2_LEANCRM_SDBCUSTOMER_PRE_$strDateAndSeq.DAT
contactFile=DM_R2_LEANCRM_SDBCONTACT_PRE_$strDateAndSeq.DAT
headLineOne=1

mysql -h$5 -u$2 -p$3 $1 < BSS_SDB_Consumer.sql > BSS_SDB_Consumer_Data.txt
awk -F"\t" -v OFS="|" ' $1=$1 ' BSS_SDB_Consumer_Data.txt > $consumerFile
sed -i 's/NULL//g' $consumerFile
consumerRecordCount=$(expr $(wc -l < $consumerFile) - $headLineOne)
footerConsumer='TRAILER_COUNT|'$consumerRecordCount
echo $footerConsumer >> $consumerFile

mysql -h$5 -u$2 -p$3 $1 < BSS_SDB_Contact.sql > BSS_SDB_Contact_Data.txt
awk -F"\t" -v OFS="|" ' $1=$1 ' BSS_SDB_Contact_Data.txt > $contactFile
sed -i 's/NULL//g' $contactFile
contactRecordCount=$(expr $(wc -l < $contactFile) - $headLineOne)
footerContact='TRAILER_COUNT|'$contactRecordCount
echo $footerContact >> $contactFile

rm BSS_SDB_Consumer_Data.txt
rm BSS_SDB_Contact_Data.txt
