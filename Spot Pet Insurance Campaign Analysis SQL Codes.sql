SET search_path TO public;

--Preview first 10 rows of each table
SELECT * 
FROM customers
LIMIT 10;

SELECT * 
FROM marketing_source
LIMIT 10;

SELECT * 
FROM cost_per_purchase
LIMIT 10;

-- Check if there are NULL values for each table
SELECT *
FROM Customers
WHERE revenue IS NULL or id IS NULL or purchase_date IS NULL; --no need to check NULL values for cancel reason column

SELECT *
FROM marketing_source
WHERE campaign IS NULL or customer_id IS NULL;

SELECT *
FROM cost_per_purchase
WHERE campaign IS NULL or cost_per_purchase IS NULL or description IS NULL;

--- Join tables to get campaign performance data
SELECT *
FROM customers c
JOIN marketing_source ms
ON c.id = ms.customer_id
LEFT JOIN cost_per_purchase cp
ON ms.campaign = cp.campaign

-- Calculate number of purchases, total revenue, profit margin, total profit, and ROI for each campaign
SELECT ms.campaign,
	cp.description,
	COUNT(c.id) as NumberOfPurchases,
	ROUND((SUM(c.revenue))::numeric, 2) as TotalRevenue,
	cp.cost_per_purchase as CostPerPurchase, 
	ROUND((((SUM(c.revenue) / COUNT(c.id)) - cp.cost_per_purchase)/(SUM(c.revenue) / COUNT(c.id)))::numeric, 3) as profitmargin_in_percentage,
	ROUND(((SUM(c.revenue) -(COUNT(c.id) * cp.cost_per_purchase)))::numeric, 2)as TotalProfit,
	ROUND(((SUM(c.revenue) - (cp.cost_per_purchase * COUNT(c.id))) / (cp.cost_per_purchase * COUNT(c.id)))::numeric, 2) as ROI_in_percentage
FROM customers c
JOIN marketing_source ms
ON c.id = ms.customer_id
LEFT JOIN cost_per_purchase cp
ON ms.campaign = cp.campaign
WHERE c.cancel_reason IS NULL -- we are not making revenue from purchases that have been cancelled, so we don't include these rows
GROUP BY ms.campaign, cp.description, cp.cost_per_purchase
ORDER BY totalprofit DESC; -- Rank campaigns by Profit Margin
--ORDER BY totalprofit DESC; -- Rank campaigns by Total Profit
-- ORDER BY numberofpurchases DESC; -- Rank campaigns by number of Purchases
