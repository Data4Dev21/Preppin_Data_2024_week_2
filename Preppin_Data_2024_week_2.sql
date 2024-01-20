/*Input the two csv files
Union the files together
Convert the Date field to a Quarter Number instead
Name this field Quarter
Aggregate the data in the following ways:
Median price per Quarter, Flow Card? and Class
Minimum price per Quarter, Flow Card? and Class
Maximum price per Quarter, Flow Card? and Class
Create three separate flows where you have only one of the aggregated measures in each. 
One for the minimum price
One for the median price
One for the maximum price
Now pivot the data to have a column per class for each quarter and whether the passenger had a flow card or not
Union these flows back together*/;


WITH CTE AS 
(
SELECT * 
FROM TIL_DATASCHOOL.DS36.PD_2024_WK02_NON_FLOW_CARDS
UNION ALL
SELECT * 
FROM TIL_DATASCHOOL.DS36.PD_2024_WK_02_FLOW_CARDS
)
, CTE1 AS
(
SELECT quarter(DATE("DATE", 'dd/MM/YYYY')) AS quarter_
      ,class
      ,flow_card
      ,round(median(price),1) as median_price
      
FROM CTE
group by quarter_, flow_card, class
order by quarter_, flow_card, class
)
, CTE2 AS
(
SELECT QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
FROM CTE1
PIVOT( max(median_price) FOR class IN ('Economy', 'Premium Economy', 'Business Class', 'First Class')) AS P
(
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
))
,
CTE3 AS
(
SELECT quarter(DATE("DATE", 'dd/MM/YYYY')) AS quarter_
      ,class
      ,flow_card
      ,max(price) as maximum_price
      
FROM CTE
group by quarter_, flow_card, class
order by quarter_, flow_card, class
)
, CTE4 AS
(
SELECT QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
      
FROM CTE3
PIVOT( max(maximum_price) FOR class IN ('Economy', 'Premium Economy', 'Business Class', 'First Class')) AS Q
(
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
))
,
CTE5 AS 
(
SELECT quarter(DATE("DATE", 'dd/MM/YYYY')) AS quarter_
      ,class
      ,flow_card
      ,min(price) as minimum_price
      
FROM CTE
group by quarter_, flow_card, class
order by quarter_, flow_card, class
)
, CTE6 AS
(
SELECT QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
FROM CTE5
PIVOT( max(minimum_price) FOR class IN ('Economy', 'Premium Economy', 'Business Class', 'First Class')) AS R
(
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
))
SELECT
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
FROM CTE2
UNION ALL
SELECT
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
FROM CTE4
UNION ALL
SELECT
QUARTER_
      ,FLOW_CARD
      ,"First Class"
      ,"Business Class"
      ,"Premium Economy"
      ,Economy
FROM CTE6;
      
      

