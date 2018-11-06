
/* Step 1 */
SELECT *
FROM survey AS sv
LIMIT 10;

/* Step 2 */

-- Summarize each question of the Style Quiz.
SELECT question, COUNT(user_id)
FROM survey AS sv
GROUP BY 1;

/* Step 4 */

SELECT *
FROM quiz as qz
LIMIT 5;

SELECT *
FROM home_try_on as hto
LIMIT 5;

SELECT *
FROM purchase as pc
LIMIT 5;

/* Step 5 */

-- Create a table to determine the number of users who
-- took the quiz and whether they proceeded to try on
-- at home and ultimately purchase.

SELECT
	 qz.user_id,
   hto.user_id NOT NULL AS 'is_home_try_on',
   hto.number_of_pairs,
 	 pc.user_id NOT NULL AS 'is_purchase'

FROM quiz AS qz

LEFT JOIN home_try_on AS hto
	ON qz.user_id = hto.user_id

LEFT JOIN purchase AS pc
	ON qz.user_id = pc.user_id

LIMIT 10;


/* Step 6 */

-- Create a temporary table to determine the number of users
-- who took the quiz and whether they proceeded to try on
-- at home and ultimately purchase.
	WITH funnel AS (SELECT
		 qz.user_id,
	   hto.user_id NOT NULL AS 'is_home_try_on',
	   hto.number_of_pairs,
	 	 pc.user_id NOT NULL AS 'is_purchase'

	FROM quiz AS qz

	LEFT JOIN home_try_on AS hto
		ON qz.user_id = hto.user_id

	LEFT JOIN purchase AS pc
		ON qz.user_id = pc.user_id)

	-- Split the population of respondents by the number of pairs
	-- received to support our A/B conversion comparison.
	SELECT number_of_pairs,
	 			 SUM(is_home_try_on) AS "tried_at_home",
				 SUM(is_purchase) AS 'made_purchase',
				 ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on),2) AS "percent_purchase"
	FROM funnel
	WHERE number_of_pairs NOT NULL
	GROUP BY 1;


/* OTHER */

-- Get a breakout of the responses to each of the questions.
SELECT question, response, COUNT(response)
FROM survey as sv
GROUP BY 2
ORDER BY 1;
