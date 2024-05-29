# Architectural Requirements

### Quality Requirements

#### 1. Performance
- **Response Time**: The system must provide real-time updates on parking slot availability within 2 seconds.
- **Throughput**: The system should handle at least 1000 concurrent user requests without performance degradation.

#### 2. Reliability
- **Uptime**: Ensure 99.9% system availability, equating to a maximum of 8.77 hours of downtime per year.
- **Fault Tolerance**: Implement redundancy to maintain functionality during hardware or software failures.

#### 3. Scalability
- **User Capacity**: The system should scale to support a growing number of users and parking lots without performance loss.
- **Data Handling**: Efficiently manage and process large volumes of data from various parking sensors and user interactions.

#### 4. Security
- **Data Protection**: Employ end-to-end encryption for data in transit and at rest to protect user information.
- **Access Control**: Implement robust user authentication and authorization mechanisms to prevent unauthorized access.
- **Compliance**: Adhere to relevant data protection regulations (e.g., GDPR) and ensure user privacy is maintained.

#### 5. Usability
- **User Interface**: Provide an intuitive and user-friendly interface with clear visual cues for parking status (available, reserved, occupied).
- **Accessibility**: Ensure the system is accessible to users with disabilities, including support for screen readers and keyboard navigation.
- **Feedback**: Offer prompt and informative feedback for user actions (e.g., booking confirmation, error messages).
- **ADD_FORMATING**: The application needs to be usable to any driver who has access to the technology that it will be hosted on. Taking this into account, the application must be intuitive enough to be able to be used on the go without much thought process going into simply booking a parking spot or viewing a parking bay’s capacity. 

#### 6. Maintainability
- **Code Quality**: Write clean, well-documented, and modular code to facilitate easy maintenance and updates.
- **Monitoring and Logging**: Implement comprehensive monitoring and logging to detect and diagnose issues promptly.
- **Updatability**: Design the system to accommodate future enhancements and technology upgrades with minimal disruption.

#### 7. Portability
- **Platform Compatibility**: Ensure compatibility across multiple platforms (web, iOS, Android) with responsive design for various device types.
- **Deployment Flexibility**: Support deployment on various cloud platforms (e.g., AWS, Azure, Google Cloud) and on-premises environments if necessary.

#### 8. Efficiency
- **Resource Utilization**: Optimize the system for efficient use of resources (e.g., CPU, memory, network bandwidth).
- **Energy Consumption**: Minimize energy consumption, particularly for IoT devices and sensors, to extend battery life and reduce operational costs.
- **ADD_FORMATING**: The app needs to smartly run without wasting resources, instead it must use resources wisely. If it does waste resources, then it will be an app that is despised by users and most probably deleted. The application will likely be run on mobile phones (due to portability). Mobile phones, in general, have lower resources compared to high performance devices. It is hence needed to have the application perform on minimal resources to operate to provide a smoother and more usable experience for the users.

#### 9. Testability
- **Automated Testing**: Implement automated testing for critical system components to ensure reliability and performance.
- **Coverage**: Achieve high test coverage for both unit tests and integration tests to validate functionality under various conditions.
- **User Testing**: Conduct usability testing with real users to gather feedback and improve the user experience.



- **ADD_FORMATING**: Flexibility: The system will be expanded as time goes on and development increases. Thus the existing system in its current state needs to be able to take on new components and use them properly and as they were built to be used. Therefore the system needs to be flexible enough as to not break just because a new component is added.

- **ADD_FORMATING**: Security: TBD, Compliance: TBD