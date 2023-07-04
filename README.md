# MediaManager

## Objective
Media Manager is an iOS mobile application that manages media files fetched from a data sources.

## Features
* App has two modes, List view and Grid view. 
* The media files can be fetched from Camera Roll, Application Bundle or Google Photos.
* Users can share media files with others via different platforms. 
* They can  delete the media files.
* The media files can be grouped based on month and year.
* It can be sorted based on their name, size and creation date.
* They can also be filtered based on their media type. 
* Media files can be marked as favorites too.
* If a particular media file is clicked, it is displayed in full screen mode.

## Implementation
* List view implemented using **UIListViewController**.
* Grid view is implemented using **UICollectionViewController**.
* The Google photos integration done using **OAuth 2.0** and **REST API** to fetch and decode the JSON meta data of the media files.
* Utilized **CoreData Framework** for the persistance of favorites.
* Used **NSCache** for Caching.
* **Dispatch Queue** for multi-threading. 

