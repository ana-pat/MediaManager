# Media Manager 
## Introduction:
Media Manager is a feature-rich iOS mobile application designed to efficiently manage media files fetched from various data sources. This technical documentation provides an overview of the application's architecture, key features, and implementation details.

## Architecture Overview:

The Media Manager application follows a structured architecture to ensure scalability, maintainability, and performance. It leverages UIKit framework for the user interface, CoreData framework for data persistence, and several other frameworks for specific functionalities.

## Key Features:

- **List View and Grid View**: Users can seamlessly switch between two modes to view media files in either a list or grid layout.
- **Data Source Integration**: The application supports fetching media files from multiple sources, including Camera Roll, Application Bundle, and Google Photos. Integration with Google Photos is achieved through OAuth 2.0 authentication and REST API for fetching and decoding JSON metadata.
- **Sharing and Deletion**: Users can easily share media files with others using various platforms. Additionally, they have the option to delete unwanted media files effortlessly.
- **Grouping and Sorting**: Media files can be grouped based on month and year, allowing users to navigate through their collection efficiently. Sorting options based on name, size, and creation date provide further customization.
- **Filtering and Favorites**: Users can filter media files based on their type, enabling quick access to specific content. Additionally, they can mark media files as favorites for easy retrieval later. CoreData framework is utilized for efficient favorite media file persistence.
- **Full-Screen Display**: When a user clicks on a particular media file, it is displayed in full-screen mode, providing a rich and immersive viewing experience.

## Implementation Details:

The Media Manager application utilizes various iOS frameworks and technologies to deliver its features and functionalities:
- **List View**: Implemented using UIListViewController, allowing users to scroll through media files efficiently.
- **Grid View**: Implemented using UICollectionViewController, providing an aesthetically pleasing and interactive grid-based media file display.
- **Google Photos Integration**: Achieved through OAuth 2.0 authentication and REST API for fetching and decoding JSON metadata.
- **CoreData Framework**: Utilized for seamless and efficient persistence of favorite media files.
- **NSCache**: Employed for caching frequently accessed media files, enhancing performance and responsiveness.
- **Dispatch Queue**: Utilized for multi-threading, ensuring smooth user experience even during resource-intensive tasks.

## Conclusion:
The Media Manager iOS application showcases my ability to learn and implement new technologies swiftly. It offers a user-friendly interface, seamless integration with various data sources, efficient data management, and optimized performance. By leveraging iOS frameworks and adopting best coding practices, the application demonstrates a robust and scalable architecture.
