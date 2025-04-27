-- To create a table
CREATE TABLE spotify_streaming_history (
	spotify_track_uri VARCHAR(255),
	ts TIMESTAMP,
	platform VARCHAR(50),
	ms_played INTEGER,
	track_name TEXT,
	artist_name TEXT,
	album_name TEXT,
	reason_start VARCHAR(50),
	reason_end VARCHAR(50),
	shuffle BOOLEAN,
	skipped BOOLEAN
)


-- To load table through import function


-- To test the data loaded into table
SELECT *
FROM spotify_streaming_history
LIMIT 10


-- To drop table
DROP TABLE spotify_streaming_history


-- To create a clean table with the calculations to finish the data cleaning process and to use for data visualization process
CREATE TABLE spotify_streaming_history_updated AS
WITH spotify_streaming_history_updated AS (
SELECT 
	*,
	COALESCE(reason_start, 'other') as reason_start_updated,
	COALESCE(reason_end, 'other') as reason_end_updated,
	ts::date AS date_calc,
	EXTRACT(YEAR FROM ts) AS year_calc,
	EXTRACT(MONTH FROM ts) AS month_calc,
	EXTRACT(DOW FROM ts) AS weekday_calc,
	TO_CHAR(ts, 'Day') AS day_of_week_name,
	ts::time AS time_calc,
	EXTRACT(HOUR FROM ts) AS hour_calc
FROM
	spotify_streaming_history
)
SELECT 
	*
FROM
	spotify_streaming_history_updated


-- To test updated table
SELECT *
FROM spotify_streaming_history_updated
LIMIT 10


-- To drop updated table
DROP TABLE spotify_streaming_history_updated


-- To find the counts for each platform and overall across the years
SELECT
    year_calc,
    SUM(CASE WHEN platform = 'iOS' THEN 1 ELSE 0 END) AS ios_counts,
    SUM(CASE WHEN platform = 'cast to device' THEN 1 ELSE 0 END) AS cast_to_device_counts,
    SUM(CASE WHEN platform = 'android' THEN 1 ELSE 0 END) AS android_counts,
    SUM(CASE WHEN platform = 'web player' THEN 1 ELSE 0 END) AS web_player_counts,
    SUM(CASE WHEN platform = 'windows' THEN 1 ELSE 0 END) AS windows_counts,
    SUM(CASE WHEN platform = 'mac' THEN 1 ELSE 0 END) AS mac_counts,
    COUNT(spotify_track_uri) AS track_count
FROM
    spotify_streaming_history_updated
GROUP BY
    year_calc
ORDER BY
    year_calc


-- To find the track counts to identify listening trends across the years 
SELECT
	year_calc,
	COUNT(spotify_track_uri) AS track_counts
FROM
	spotify_streaming_history_updated
GROUP BY
	year_calc
ORDER BY
	year_calc


-- To find the track counts to identify listening trends across the day of the week 
SELECT
	weekday_calc,
	COUNT(spotify_track_uri) AS track_counts
FROM
	spotify_streaming_history_updated
GROUP BY
	weekday_calc
ORDER BY
	weekday_calc


-- To find the track counts to identify listening trends across the time of day 
SELECT
	hour_calc,
	COUNT(spotify_track_uri) AS track_counts
FROM
	spotify_streaming_history_updated
GROUP BY
	hour_calc
ORDER BY
	hour_calc


-- To find the time spent on the app by year
SELECT
	year_calc,
	SUM(ms_played) / 60000 AS total_minutes_played
FROM
	spotify_streaming_history_updated
GROUP BY
	year_calc
ORDER BY
	year_calc


-- To find the top 5 tracks to find the popular tracks overall
SELECT
	spotify_track_uri,
	COUNT(*) as track_count,
	track_name,
	artist_name,
	album_name
FROM
	spotify_streaming_history_updated
GROUP BY
	spotify_track_uri, track_name, artist_name, album_name
ORDER BY
	track_count DESC
LIMIT 5


-- To find the top 5 tracks to find the popular tracks in 2024
SELECT
	spotify_track_uri,
	COUNT(*) as track_count,
	track_name,
	artist_name,
	album_name
FROM
	spotify_streaming_history_updated
WHERE
	year_calc = 2024
GROUP BY
	spotify_track_uri, track_name, artist_name, album_name
ORDER BY
	track_count DESC
LIMIT 5


-- To find the top 5 artists to find the popular artists overall
SELECT
	artist_name,
	COUNT(*) as artist_count
FROM
	spotify_streaming_history_updated
GROUP BY
	artist_name
ORDER BY
	artist_count DESC
LIMIT 5


-- To find the top 5 artists to find the popular artists in 2024
SELECT
	artist_name,
	COUNT(*) as artist_count
FROM
	spotify_streaming_history_updated
WHERE
	year_calc = 2024
GROUP BY
	artist_name
ORDER BY
	artist_count DESC
LIMIT 5


-- To find out how often shuffle is being used overall
SELECT
    shuffle,
    COUNT(*) AS count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify_streaming_history_updated)), 1) AS percentage
FROM
    spotify_streaming_history_updated
GROUP BY
    shuffle


-- To find out how often shuffle is being used by year
WITH yearly_shuffle AS (
    SELECT
        year_calc,
        shuffle,
        COUNT(*) AS shuffle_count
    FROM
        spotify_streaming_history_updated
    GROUP BY
        year_calc, shuffle
),
yearly_shuffle_pivot AS (
    SELECT
        year_calc,
        SUM(CASE WHEN shuffle = TRUE THEN shuffle_count ELSE 0 END) AS shuffle_true_count,
        SUM(CASE WHEN shuffle = FALSE THEN shuffle_count ELSE 0 END) AS shuffle_false_count,
        SUM(shuffle_count) AS total_count
    FROM
        yearly_shuffle
    GROUP BY
        year_calc
    ORDER BY
        year_calc
)
SELECT
    year_calc,
	ROUND((shuffle_true_count * 100.0 / total_count), 2) AS shuffle_true_percentage,
    ROUND((shuffle_false_count * 100.0 / total_count), 2) AS shuffle_false_percentage
FROM
    yearly_shuffle_pivot


-- To find the reasons for starting a track and the instances
SELECT
    reason_start,
    COUNT(*) AS start_count
FROM
    spotify_streaming_history_updated
GROUP BY
    reason_start
ORDER BY
    start_count DESC


-- To find the reasons for ending a track and the instances
SELECT
    reason_end,
    COUNT(*) AS end_count
FROM
    spotify_streaming_history_updated
GROUP BY
    reason_end
ORDER BY
    end_count DESC


-- To find the average listening duration of tracks overall
SELECT
    ROUND(AVG(ms_played) / 60000, 2) AS average_minutes_played
FROM
    spotify_streaming_history_updated


-- To find the average listening duration of tracks by year
SELECT
	year_calc,
    ROUND(AVG(ms_played) / 60000, 2) AS average_minutes_played
FROM
    spotify_streaming_history_updated
GROUP BY
	year_calc
ORDER BY year_calc