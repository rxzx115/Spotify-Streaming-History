# Spotify-Streaming-History

## Objective
To understand user preferences and consumption patterns to increase user satisfaction and platform retention

## Guiding Questions
- What are the most common listening patterns (e.g., preferred artists, tracks, albums, listening durations) of this user?
- How does the user interact with the platform in terms of playback initiation (e.g., playlist, trackdone, clickrow)?
- What is the user's preferred listening context or mode (e.g., shuffle vs. non-shuffle)?
- What trends or shifts are there in the user's listening habits over the recorded timeframe (e.g., reason start, reason end, shuffle)?
- What signs are there of dissatisfaction or disengagement through the skipping behavior?
- What time of day do they typically listen to music? o	How often do they explore new artists versus replaying favorites?

## Data Collection
To retrieve data from Kaggle

## Data Cleaning
- Investigated different date data formats for data quality
- Reviewed duplicates for data integrity
- Reviewed outliers to avoid errors or unusual events

## Data Exploration
- Exploratory data analysis was performed in SQL to answer the guiding questions
- Refer to the separate .sql file for further details

## Data Visualization
- Data visualization was performed in Tableau
- Refer to the separate Tableau data visualization on Tableau Public for further details

## Insights and Recommendations
1. Significant decrease in overall engagement with the Spotify platform.
    - Investigate the underlying reasons for this decreasing engagement, including 1) user surveys/interviews about their listening habits or satisfaction with the platform, 2) analyzing feature usage (e.g., playlists, podcasts, social sharing), and 3) competitive analysis to understanding user migration to competitor platforms.
2. "Trackdone" is the top reason for both starting and ending tracks.
    - Prioritize and optimize the algorithms that drive the experience, including Autoplay and Radio features, seamless transitions, contextual continuations.
3. Decreasing "fwdbtn" end reason with increasing skip rate.
    - Investigate the reasons behind the rising skip rate, potentially analyzing which types of content are skipped most. Refine recommendation algorithms and explore more granular user controls over playback and discovery.
4. Potential issue with "endplay" definition.
    - Immediately clarify the definition and tracking of "endplay" with the relevant data and engineering teams to ensure accurate analysis and insights.
