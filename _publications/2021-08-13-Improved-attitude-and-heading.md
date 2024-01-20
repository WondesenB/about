---
title: "Improved attitude and heading accuracy with double quaternion parameters estimation and magnetic disturbance rejection"
collection: publications
permalink: /publications/2021-08-13-Improved-attitude-and-heading/
excerpt: 'Despite the boom in UAV applications, cheap MEMS sensors pose a challenge: their data is easily corrupted by noise, leading to inaccurate orientation estimates. This study tackles this issue by proposing a novel EKF method with double quaternion parameters, effectively decoupling the magnetometer from attitude calculations. An online error tuning system further combats magnetic noise. Tests reveal the methods superiority over traditional EKF approaches, paving the way for more robust UAV navigation.'
date: 2021-08-13
venue: 'Sensors'
paperurl: 'https://doi.org/10.3390/s21165475'
citation: 'Wondosen, A.; Jeong, J.-S.; Kim, S.-K.; Debele, Y.; Kang, B.-S. Improved Attitude and Heading Accuracy with Double Quaternion Parameters Estimation and Magnetic Disturbance Rejection. Sensors 2021, 21, 5475. https://doi.org/10.3390/s21165475'
---
Abstract:
The use of unmanned aerial vehicle (UAV) applications has grown rapidly over the past decade with the introduction of low-cost microelectromechanical system (MEMS)-based sensors that measure angular velocity, gravity, and magnetic field, which are important for an object orientation determination. However, the use of low-cost sensors has also been limited because their readings are easily distorted by unwanted internal and/or external noise signals such as environmental magnetic disturbance, which lead to errors in attitude and heading estimation results. In an extended Kalman filter (EKF) process, this study proposes a method for mitigating the effect of magnetic disturbance on attitude determination by using a double quaternion parameters for representation of orientation states, which decouples the magnetometer from attitude computation. Additionally, an online measurement error covariance matrix tuning system was implemented to reject the impact of magnetic disturbance on the heading estimation. Simulation and experimental tests were conducted to verify the performance of the proposed methods in resolving the magnetic noise effect on attitude and heading. The results showed that the proposed method performed better than complimentary, gradient descent, and single quaternion-based EKF.

[Download paper here](http://wondesenb.github.io/about/papers/sensors-21-05475-v2.pdf)
