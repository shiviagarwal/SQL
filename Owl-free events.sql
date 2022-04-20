
WITH NonOwlEvents AS (

	-- get events which don't contain O, W or L
	SELECT
		e.EventId,
		e.EventName,
		e.EventDate,
		e.CountryID,
		e.CategoryID
	FROM
		tblEvent AS e
	WHERE
		e.EventDetails not like '%o%' and
		e.EventDetails not like '%w%' and
		e.EventDetails not like '%l%' 
)

-- link to this first list to show events for these countries, then for these 
-- countries show events occurring in them
, OtherEventsInNonOwlCountries AS (

	SELECT DISTINCT
		c.CountryName,
		e.EventName,
		e.CategoryID
	FROM
		NonOwlEvents AS noe
		INNER JOIN tblCountry AS c
			ON noe.CountryID = c.CountryID
		INNER JOIN tblEvent AS e
			ON noe.CountryID = e.CountryID
)

-- finally, for this second lot of events, find the categories they use
-- and show all events for these categories!
SELECT DISTINCT
	e.EventName,
	e.EventDate,
	c.CategoryName,
	cy.CountryName
FROM
	OtherEventsInNonOwlCountries AS other
	INNER JOIN tblCategory AS c
		ON other.CategoryID = c.CategoryID
	INNER JOIN tblEvent AS e
		ON c.CategoryID = e.CategoryID
	INNER JOIN tblCountry AS cy
		ON e.CountryID = cy.CountryID
ORDER BY
	e.EventDate