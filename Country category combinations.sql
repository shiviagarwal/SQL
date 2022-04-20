
WITH TopCountries AS (

	-- get the ids of the 3 countries with the most events
	SELECT TOP 3
		c.CountryId,
		COUNT(*) AS NumberEvents
	FROM
		tblCountry AS c
		INNER JOIN tblEvent AS e
			ON c.CountryID = e.CountryID
	GROUP BY
		c.CountryId
	ORDER BY
		NumberEvents DESC
), TopCategories AS (

	-- now get the ids of the 3 categories with the most events
	SELECT TOP 3
		c.CategoryId,
		COUNT(*) AS NumberEvents
	FROM
		tblCategory AS c
		INNER JOIN tblEvent AS e
			ON c.CategoryID = e.CategoryID
	GROUP BY
		c.CategoryId
	ORDER BY
		NumberEvents DESC
), combos AS (

	-- combine these together (every possible combination)
	SELECT
		cy.CountryID,
		cg.CategoryID
	FROM
		TopCountries AS cy
		CROSS JOIN TopCategories AS cg
)

-- count the number of events for each combination
SELECT
	cy.CountryName,
	cg.CategoryName,
	COUNT(*) AS NumberEvents
FROM
	combos AS co
	INNER JOIN tblCountry AS cy
		ON co.CountryID = cy.CountryID
	INNER JOIN tblCategory AS cg
		ON co.CategoryID = cg.CategoryID
	INNER JOIN tblEvent AS e 
		ON co.CategoryID = e.CategoryID AND
		co.CountryID = e.CountryID
GROUP BY
	cy.CountryName,
	cg.CategoryName
ORDER BY
	NumberEvents DESC
