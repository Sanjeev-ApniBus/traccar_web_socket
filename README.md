#Traccar WebSocket Testing in Flutter

Table of Contents:

- Installation
- Usage
- Code Explanation
- Dependencies
- Contributing
- License

Installation:

1. Clone the repository:
   git clone https://github.com/sanjeev-Apnibus/traccar-websocket-testing.git

2. Navigate to the project directory:
   cd traccar-websocket-testing

3. Install dependencies:
   flutter pub get

Usage:

1. Open lib/main.dart in your code editor.
2. Locate the TraccarWebSocketTesting class, which is the main application logic.
3. Run the app:
   flutter run

4. Press the "Start WebSocket" button in the app to connect to Traccar's demo server.

Code Explanation:

- WebSocket Connection Setup:
    - The `establishHttpSession` method manages authentication with Traccar's server and establishes a WebSocket connection using the obtained session cookie.
    - The WebSocket connection is managed using the `IOWebSocketChannel` class.

- Data Parsing:
    - Received WebSocket data is parsed and processed in the `_channel!.stream.listen` callback.
    - The `PositionListModel` and `PositionModel` classes are utilized to deserialize JSON data into Dart objects.

- UI Display:
    - The application's UI displays the most recent position's device time in the center of the screen.
    - The UI is updated dynamically as new position updates are received.

Dependencies:

- [http](https://pub.dev/packages/http): Used for making HTTP requests.
- [web_socket_channel](https://pub.dev/packages/web_socket_channel): Utilized for handling WebSocket connections.

Contributing:

Contributions to the project are welcome! Feel free to open an issue or submit a pull request.

License:

This project is licensed under the MIT License.

