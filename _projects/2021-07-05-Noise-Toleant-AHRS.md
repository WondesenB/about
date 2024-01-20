---
title: "Magnetic Disturbance Tolerant AHRS"
collection: projects
type: "Research Project"
permalink: /projects/Noise-Tolerant-AHRS/
venue: "Pusan National University, Departmnet of Aerospace Engineering"
date: 2021-07-05
location: "Busan, Korea"
---
This project focuses on creating a reliable Attitude and Heading Reference System (AHRS) algorithm using real-time data from the ICM-20948 sensor. Specifically designed firmware code was developed for deployment on the TMS320F28377S Texas Instrument processor, enabling the achievement of a high accuracy AHRS estimation at an impressive output rate of 110 Hz. The demonstration in the provided video showcases this accuracy. Moreover, a pivotal feature of the project involves implementing data export in the MAVLINK protocol, facilitating seamless interfacing for UAV and robotics applications, thereby enhancing accessibility and usability within these domains.

Source code
=======
[Code](https://github.com/WondesenB/AHRS_Firmware.git)

Results
======
- Custom Software Visualization

[video 1](https://youtu.be/k1rQOr5Ajhw)

[![video](http://wondesenb.github.io/about/thumnails/thumnail-ahrs-sw-view.png)](https://youtu.be/k1rQOr5Ajhw)

 - Qgroundcontrol Visualization using MAVLINK

[video 2](https://youtu.be/KnzcqsosoNA)

[![video](http://wondesenb.github.io/about/thumnails/thumnail-ahrs-qgctrl-view.png)](https://youtu.be/KnzcqsosoNA)

<!-- <iframe width="960" height="540" src="https://youtu.be/D8bIGT2S5dI" frameborder="0" allowfullscreen></iframe> -->

Citation
========
Wondosen, A.; Jeong, J.-S.; Kim, S.-K.; Debele, Y.; Kang, B.-S. Improved Attitude and Heading Accuracy with Double Quaternion Parameters Estimation and Magnetic Disturbance Rejection. Sensors 2021, 21, 5475. https://doi.org/10.3390/s21165475
