^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package mqtt_client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.2.1 (2023-02-16)
------------------
* Merge pull request #6 from oxin-ros/feat/add-support-for-utf8-decoding
  - Adds support for bistream types based on utf-8 encoding of MQTT message payload.
* Contributors: David B.

1.2.0 (2023-02-15)
------------------
* Merge pull request #1 from oxin-ros/feat/aws-tls-support
  - Adds support for ALPN protocol names, which is used by AWS IoT Core.
  - Adds support for GCC < 9 by using `https://github.com/gulrak/filesystem` to add support for std::filesystem API.
  - Adds support for YAML array parameter loading.
* Merge pull request #2 from oxin-ros/fix/paho-mqtt-cpp-rosdep-melodic
  - Fixes the catkin build for ROS Melodic.
* Merge pull request #3 from oxin-ros/feat/add-mqtt-prefix
  - Adds support for specifying a common MQTT topic prefix across all the MQTT topics.
* Merge pull request #4 from oxin-ros/feat/add-json-support
  - Adds support for json_msgs::Json types through a primitive MQTT topic.
* Contributors: David B.

1.1.0 (2022-10-13)
------------------
* Merge pull request #6 from ika-rwth-aachen/feature/primitive-msgs
  Support exchange of primitive messages with other MQTT clients
* Contributors: Lennart Reiher

1.0.2 (2022-10-07)
------------------
* Merge pull request #4 from ika-rwth-aachen/improvement/runtime-optimization
  Optimize runtime
* Merge pull request #5 from ika-rwth-aachen/ci
  Set up CI
* Contributors: Lennart Reiher

1.0.1 (2022-08-11)
------------------
* Merge pull request #3 from ika-rwth-aachen/doc/code-api
  Improve Code API Documentation
* Merge pull request #1 from ika-rwth-aachen/improvement/documentation
  Improve documentation
* Contributors: Lennart Reiher
