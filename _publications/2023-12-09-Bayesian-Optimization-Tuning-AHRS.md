---
title: "Bayesian Optimization for Fine-Tuning EKF Parameters in UAV Attitude and Heading Reference System Estimation"
collection: publications
permalink: /publications/2023-12-09-Bayesian-Optimization-Tuning-AHRS/
excerpt: 'Accurately estimating a vehicles 3D motion and seamlessly fusing data from multiple sensors are crucial tasks in various applications. While the Extended Kalman Filter (EKF) reigns supreme in this domain, its effectiveness hinges on optimal tuning of two key parameters: the process and measurement noise covariance matrices (Q and R). Choosing these values correctly can be a daunting challenge, hindering the EKFs full potential.

This research tackles this challenge head-on by proposing an EKF innovation consistency statistics-driven Bayesian optimization algorithm. This novel approach automatically tunes Q and R based on the desired performance criteria, specifically, minimizing estimation error through improved measurement innovation consistency. Our extensive results showcase a significant performance boost in the EKF when equipped with the optimized Q and R values obtained through our algorithm.

**In essence, this research paves the way for easier and more effective utilization of the EKF in various vehicle motion estimation and sensor fusion applications.**'
date: 2023-12-09
venue: 'Aerospace'
paperurl: 'https://doi.org/10.3390/aerospace10121023'
citation: 'Wondosen, A.; Debele, Y.; Kim, S.-K.; Shi, H.-Y.; Endale, B.; Kang, B.-S. Bayesian Optimization for Fine-Tuning EKF Parameters in UAV Attitude and Heading Reference System Estimation. Aerospace 2023, 10, 1023. https://doi.org/10.3390/aerospace10121023'
---
Abstract:
In various applications, the extended Kalman filter (EKF) has been vital in estimating a vehicle’s translational and angular motion in 3-dimensional (3D) space. It is also essential for the fusion of data from multiple sensors. However, for the EKF to perform effectively, the optimal process noise covariance matrix (Q) and measurement noise covariance matrix (R) must be chosen correctly. The use of EKF has been challenging due to the need for an easy mechanism to select Q and R values. As a result, this research focused on developing an algorithm that can be easily applied to determine Q and R, allowing us to harness the full potential of EKF. Accordingly, an EKF innovation consistency statistics-driven Bayesian optimization algorithm was employed to achieve this goal. Q and R values were tuned until the expected result met the performance requirement for minimum error through improved measurement innovation consistency. The comprehensive results demonstrate that when the optimum Q and R, as tuned by the suggested technique, were used, the performance of the EKF significantly improved.

[Download paper here](http://wondesenb.github.io/about/papers/aerospace-10-01023-v2.pdf)
