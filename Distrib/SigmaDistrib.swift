//
// Statistics library written in Swift.
//
// https://github.com/evgenyneu/SigmaSwiftStatistics
//
// This file was automatically generated by combining multiple Swift source files.
//


// ----------------------------
//
// CentralMoment.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 19/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//

import Foundation

public extension Sigma {
  /**
   
  Computes central moment of the dataset.
   
  https://en.wikipedia.org/wiki/Central_moment

  - parameter values: Array of decimal numbers.
  - parameter order: The order of the moment (0, 1, 2, 3 etc.).
  - returns: Central moment. Returns nil when the array is empty.
   
  Formula:

      Σ(x - m)^k / n

  Where:

  m is the sample mean.
   
  k is the order of the moment (0, 1, 2, 3, ...).
   
  n is the sample size.
   
  Example:
   
      Sigma.centralMoment([3, -1, 1, 4.1, 4.1, 0.7], order: 3) // -1.5999259259
   
  */
  public static func centralMoment(_ values: [Double], order: Int) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    guard let averageVal = average(values) else { return nil }
    
    let total = values.reduce(0) { sum, value in
      sum + pow((value - averageVal), Double(order))
    }
    
    return total / count
  }
}


// ----------------------------
//
// CoefficientVariation.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 21/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//

import Foundation

public extension Sigma {
  /**

  Computes coefficient of variation based on a sample.

  https://en.wikipedia.org/wiki/Coefficient_of_variation

  - parameter values: Array of decimal numbers.
  - returns: Coefficient of variation of a sample. Returns nil when the array is empty or contains a single value. Returns Double.infinity if the mean is zero.

  Formula:

      CV = s / m
 
  Where:

  s is the sample standard deviation.

  m is the mean.

  Example:

      Sigma.coefficientOfVariationSample([1, 12, 19.5, -5, 3, 8]) // 1.3518226672

  */
  public static func coefficientOfVariationSample(_ values: [Double]) -> Double? {
    if values.count < 2 { return nil }
    guard let stdDev = Sigma.standardDeviationSample(values) else { return nil }
    guard let avg = average(values) else { return nil }
    if avg == 0 { return stdDev >= 0 ? Double.infinity : -Double.infinity }
    return stdDev / avg
  }
}


// ----------------------------
//
// Covariance.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**

  Computes covariance of a sample between two variables: x and y.

  http://en.wikipedia.org/wiki/Sample_mean_and_sample_covariance

  - parameter x: Array of decimal numbers for the first variable.
  - parameter y: Array of decimal numbers for the second variable.
  - returns: Covariance of a sample between two variables: x and y. Returns nil if arrays x and y have different number of values. Returns nil for empty arrays or arrays containing a single element.

  Formula:

      cov(x,y) = Σ(x - mx)(y - my) / (n - 1)

  Where:

  mx is the sample mean of the first variable.

  my is the sample mean of the second variable.

  n is the total number of values.

  Example:

      let x = [1, 2, 3.5, 3.7, 8, 12]
      let y = [0.5, 1, 2.1, 3.4, 3.4, 4]
      Sigma.covarianceSample(x: x, y: y) // 5.03

  */
  public static func covarianceSample(x: [Double], y: [Double]) -> Double? {
    let xCount = Double(x.count)
    let yCount = Double(y.count)
    
    if xCount < 2 { return nil }
    if xCount != yCount { return nil }
    
    if let xMean = average(x),
      let yMean = average(y) {
      
      var sum:Double = 0
      
      for (index, xElement) in x.enumerated() {
        let yElement = y[index]
        
        sum += (xElement - xMean) * (yElement - yMean)
      }
      
      return sum / (xCount - 1)
    }
    
    return nil
  }
  
  /**
   
   Computes covariance for entire population between two variables: x and y.
   
   http://en.wikipedia.org/wiki/Covariance
   
   - parameter x: Array of decimal numbers for the first variable.
   - parameter y: Array of decimal numbers for the second variable.
   - returns: Covariance for entire population between two variables: x and y. Returns nil if arrays x and y have different number of values. Returns nil for empty arrays.
   
   Formula:
   
       cov(x,y) = Σ(x - mx)(y - my) / n
   
   Where:
   
   mx is the population mean of the first variable.
   
   my is the population mean of the second variable.
   
   n is the total number of values.
   
   Example:
   
       let x = [1, 2, 3.5, 3.7, 8, 12]
       let y = [0.5, 1, 2.1, 3.4, 3.4, 4]
       Sigma.covariancePopulation(x: x, y: y) // 4.19166666666667
   
   */
  public static func covariancePopulation(x: [Double], y: [Double]) -> Double? {
    let xCount = Double(x.count)
    let yCount = Double(y.count)
    
    if xCount == 0 { return nil }
    if xCount != yCount { return nil }
    
    if let xMean = average(x),
      let yMean = average(y) {
      
      var sum:Double = 0
      
      for (index, xElement) in x.enumerated() {
        let yElement = y[index]
        
        sum += (xElement - xMean) * (yElement - yMean)
      }
      
      return sum / xCount
    }
    
    return nil
  }
}


// ----------------------------
//
// Kurtosis.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 19/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//


import Foundation

public extension Sigma {
  /**

  Computes kurtosis of a series of numbers. This implementation is the same as the SKEW function in Excel and Google Docs Sheets.

  https://en.wikipedia.org/wiki/Kurtosis

  - parameter values: Array of decimal numbers.
   
  - returns: Kurtosis. Returns nil if the dataset contains less than 4 values. Returns nil if all the values in the dataset are the same.

  Formula (LaTeX):

      rac{n(n + 1)}{(n - 1)(n - 2)(n - 3)}\sum_{i=1}^{n} \Bigg( rac{x_i - ar{x}}{s} \Bigg)^4 - rac{3(n - 1)^2}{(n - 2)(n - 3)}

  Example:

      Sigma.kurtosisA([2, 1, 3, 4.1, 19, 1.5]) // 5.4570693277

  */
  public static func kurtosisA(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count < 4 { return nil }
    
    guard let averageVal = average(values) else { return nil }
    guard let stdev = standardDeviationSample(values) else { return nil }
    
    var result = values.reduce(0.0) { sum, value in
      let value = (value - averageVal) / stdev
      return sum + pow(value, 4)
    }
    
    result *= (count * (count + 1) / ((count - 1) * (count - 2) * (count - 3)))
    result -= 3 * pow(count - 1, 2) / ((count - 2) * (count - 3))
    
    return result
  }
  
  /**

  Computes kurtosis of a series of numbers. This implementation is the same as in Wolfram Alpha and "moments" R package.

  https://en.wikipedia.org/wiki/Kurtosis

  - parameter values: Array of decimal numbers.

  - returns: Kurtosis. Returns nil if the dataset contains less than 2 values. Returns nil if all the values in the dataset are the same.

  Formula (LaTeX):

      rac{\mu_4}{\mu^2_2}

  Example:

      Sigma.kurtosisB([2, 1, 3, 4.1, 19, 1.5]) // 4.0138523409

  */
  public static func kurtosisB(_ values: [Double]) -> Double? {
    if values.isEmpty { return nil }
    guard let moment4 = centralMoment(values, order: 4) else { return nil }
    guard let moment2 = centralMoment(values, order: 2) else { return nil }
    if moment2 == 0 { return nil }
    return (moment4 / pow(moment2, 2))
  }
}


// ----------------------------
//
// Median.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**
   
   Returns the central value from the array after it is sorted.
   
   http://en.wikipedia.org/wiki/Median
   
   - parameter values: Array of decimal numbers.
   - returns: The median value from the array. Returns nil for an empty array. Returns the mean of the two middle values if there is an even number of items in the array.
   
   Example:
   
   Sigma.median([1, 12, 19.5, 3, -5]) // 3
   
   */
  public static func median(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    let sorted = Sigma.sort(values)
    
    if count.truncatingRemainder(dividingBy: 2) == 0 {
      // Even number of items - return the mean of two middle values
      let leftIndex = Int(count / 2 - 1)
      let leftValue = sorted[leftIndex]
      let rightValue = sorted[leftIndex + 1]
      return (leftValue + rightValue) / 2
    } else {
      // Odd number of items - take the middle item.
      return sorted[Int(count / 2)]
    }
  }
  
  /**
   
   Returns the central value from the array after it is sorted.
   
   http://en.wikipedia.org/wiki/Median
   
   - parameter values: Array of decimal numbers.
   - returns: The median value from the array. Returns nil for an empty array. Returns the smaller of the two middle values if there is an even number of items in the array.
   
   Example:
   
   Sigma.medianLow([1, 12, 19.5, 10, 3, -5]) // 3
   
   */
  public static func medianLow(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    let sorted = values.sorted { $0 < $1 }
    
    if count.truncatingRemainder(dividingBy: 2) == 0 {
      // Even number of items - return the lower of the two middle values
      return sorted[Int(count / 2) - 1]
    } else {
      // Odd number of items - take the middle item.
      return sorted[Int(count / 2)]
    }
  }
  
  /**
   
   Returns the central value from the array after it is sorted.
   
   http://en.wikipedia.org/wiki/Median
   
   - parameter values: Array of decimal numbers.
   - returns: The median value from the array. Returns nil for an empty array. Returns the greater of the two middle values if there is an even number of items in the array.
   
   Example:
   
   Sigma.medianHigh([1, 12, 19.5, 10, 3, -5]) // 10
   
   */
  public static func medianHigh(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    let sorted = values.sorted { $0 < $1 }
    return sorted[Int(count / 2)]
  }
}


// ----------------------------
//
// Normal.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  
  /**
   
   Returns the normal distribution for the given values of x, μ and σ. The returned value is the area under the normal curve to the left of the value x.
   
   https://en.wikipedia.org/wiki/Normal_distribution
   
   - parameter x: The input value.
   
   - parameter μ: The mean. Default: 0.
   
   - parameter σ: The standard deviation. Default: 1.
   
   - returns: The value of the normal distribution. The returned value is the area under the normal curve to the left of the value x. Returns nil if σ is zero or negative.
   
   
   Example:
   
       Sigma.normalDistribution(x: -1, μ: 0, σ: 1) // 0.1586552539314570
   
   */
  public static func normalDistribution(x: Double, μ: Double = 0, σ: Double = 1) -> Double? {
    if σ <= 0 { return nil }
    let z = (x - μ) / σ
    return  0.5 * erfc(-z * M_SQRT1_2)
  }
  
  /**

  Returns the value of the normal density function.

  https://en.wikipedia.org/wiki/Normal_distribution

  - parameter x: The input value of the normal density function.

  - parameter μ: The mean. Default: 0.

  - parameter σ: The standard deviation. Default: 1.

  - returns: The value of the normal density function. Returns nil if σ is zero or negative.

  Formula (LaTeX):

      rac{1}{\sqrt{2 \sigma^2 \pi}} e^{ - rac{(x - \mu)^2}{2 \sigma^2} }

  Where:

  x is the input value of the normal density function.

  μ is the mean.

  σ is the standard deviation.


  Example:

      Sigma.normalDensity(x: 0, μ: 0, σ: 1) // 0.3989422804014327

  */
  public static func normalDensity(x: Double, μ: Double = 0, σ: Double = 1) -> Double?  {
    if σ <= 0 { return nil }
    return (1 / sqrt(2 * pow(σ,2) * M_PI)) * pow(M_E, (-( pow(x - μ, 2) / (2 * pow(σ, 2)) )))
  }
  
  /**
   
   Returns the quantile function for the normal distribution.
   
   https://en.wikipedia.org/wiki/Normal_distribution
   
   - parameter p: The probability (area under the normal curve to the left of the returned value).
   
   - parameter μ: The mean. Default: 0.
   
   - parameter σ: The standard deviation. Default: 1.
   
   - returns: The quantile function for the normal distribution. Returns nil if σ is zero or negative. Returns nil if p is negative or greater than one. Returns (-Double.infinity) if p is zero. Returns Double.infinity if p is one.
   
   
   Example:
   
       Sigma.normalQuantile(p: 0.025, μ: 0, σ: 1) // -1.9599639845400538
   
  */
  public static func normalQuantile(p: Double, μ: Double = 0, σ: Double = 1) -> Double? {
    return qnorm(p: p, mu: μ, sigma: σ)
  }
  
  // MARK: - Protected functionality
  
  /*
   *
   *  Mathlib : A C Library of Special Functions
   *  Copyright (C) 1998       Ross Ihaka
   *  Copyright (C) 2000--2005 The R Core Team
   *  based on AS 111 (C) 1977 Royal Statistical Society
   *  and   on AS 241 (C) 1988 Royal Statistical Society
   *
   *  This program is free software; you can redistribute it and/or modify
   *  it under the terms of the GNU General Public License as published by
   *  the Free Software Foundation; either version 2 of the License, or
   *  (at your option) any later version.
   *
   *  This program is distributed in the hope that it will be useful,
   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   *  GNU General Public License for more details.
   *
   *  You should have received a copy of the GNU General Public License
   *  along with this program; if not, a copy is available at
   *  https://www.R-project.org/Licenses/
   *  
   *  DESCRIPTION
   *
   *	Compute the quantile function for the normal distribution.
   *
   *	For small to moderate probabilities, algorithm referenced
   *	below is used to obtain an initial approximation which is
   *	polished with a final Newton step.
   *
   *	For very large arguments, an algorithm of Wichura is used.
   *
   *  REFERENCE
   *
   *	Beasley, J. D. and S. G. Springer (1977).
   *	Algorithm AS 111: The percentage points of the normal distribution,
   *	Applied Statistics, 26, 118-121.
   *
   *      Wichura, M.J. (1988).
   *      Algorithm AS 241: The Percentage Points of the Normal Distribution.
   *      Applied Statistics, 37, 477-484.
   */
  
  /**
   
   Computes the quantile function for the normal distribution.
   
   Adapted from: https://svn.r-project.org/R/trunk/src/nmath/qnorm.c
   
   - parameter p: The probability.
   
   - parameter μ: The mean.
   
   - parameter σ: The standard deviation.
   
   - returns: The quantile function for the normal distribution. Returns nil if σ is zero or negative. Returns nil if p is negative or greater than one. Returns (-Double.infinity) if p is zero. Returns Double.infinity if p is one.
   
  */
  static func qnorm(p: Double, mu: Double, sigma: Double) -> Double? {
    if (p < 0 || p > 1) { return nil }
    if (p == 0) { return -Double.infinity }
    if (p == 1) { return Double.infinity }
    if (sigma <= 0) { return nil }
    let q = p - 0.5
    var val: Double = 0, r: Double = 0
    
    if (abs(q) <= 0.425) // 0.075 <= p <= 0.925
    {
      r = 0.180625 - q * q;
      val = q * (((((((r * 2509.0809287301226727 +
        33430.575583588128105) * r + 67265.770927008700853) * r +
        45921.953931549871457) * r + 13731.693765509461125) * r +
        1971.5909503065514427) * r + 133.14166789178437745) * r +
        3.387132872796366608)
        / (((((((r * 5226.495278852854561 +
          28729.085735721942674) * r + 39307.89580009271061) * r +
          21213.794301586595867) * r + 5394.1960214247511077) * r +
          687.1870074920579083) * r + 42.313330701600911252) * r + 1.0);
    } else /* closer than 0.075 from {0,1} boundary */
    {
      r = q > 0 ? 1 - p : p;
      r = sqrt(-log(r))
      
      if (r <= 5) // <==> min(p,1-p) >= exp(-25) ~= 1.3888e-11
      {
        r -= 1.6;
        val = (((((((r * 7.7454501427834140764e-4 +
          0.0227238449892691845833) * r + 0.24178072517745061177) *
          r + 1.27045825245236838258) * r +
          3.64784832476320460504) * r + 5.7694972214606914055) *
          r + 4.6303378461565452959) * r +
          1.42343711074968357734)
          / (((((((r *
            1.05075007164441684324e-9 + 5.475938084995344946e-4) *
            r + 0.0151986665636164571966) * r +
            0.14810397642748007459) * r + 0.68976733498510000455) *
            r + 1.6763848301838038494) * r +
            2.05319162663775882187) * r + 1.0);
      }
      else // very close to  0 or 1
      {
        r -= 5.0;
        val = (((((((r * 2.01033439929228813265e-7 +
          2.71155556874348757815e-5) * r +
          0.0012426609473880784386) * r + 0.026532189526576123093) *
          r + 0.29656057182850489123) * r +
          1.7848265399172913358) * r + 5.4637849111641143699) *
          r + 6.6579046435011037772)
          / (((((((r *
            2.04426310338993978564e-15 + 1.4215117583164458887e-7) *
            r + 1.8463183175100546818e-5) * r +
            7.868691311456132591e-4) * r + 0.0148753612908506148525)
            * r + 0.13692988092273580531) * r +
            0.59983220655588793769) * r + 1.0);
      }
      if (q < 0.0) { val = -val; }
    }
    
    return (mu + sigma * val)
  }
}


// ----------------------------
//
// Pearson.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**

  Calculates the Pearson product-moment correlation coefficient between two variables: x and y.

  http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient

  - parameter x: Array of decimal numbers for the first variable.
  - parameter y: Array of decimal numbers for the second variable.
  - returns: The Pearson product-moment correlation coefficient between two variables: x and y. Returns nil if arrays x and y have different number of values. Returns nil for empty arrays.

  Formula:

      p(x,y) = cov(x,y) / (σx * σy)

  Where:

  cov is the population covariance.

  σx is the population standard deviation of x.

  Example:

      let x = [1, 2, 3.5, 3.7, 8, 12]
      let y = [0.5, 1, 2.1, 3.4, 3.4, 4]
      Sigma.pearson(x: x, y: y) // 0.843760859352745

  */
  public static func pearson(x: [Double], y: [Double]) -> Double? {
    if let cov = Sigma.covariancePopulation(x: x, y: y),
      let σx = Sigma.standardDeviationPopulation(x),
      let σy = Sigma.standardDeviationPopulation(y) {
      
      if σx == 0 || σy == 0 { return nil }
      
      return cov / (σx * σy)
    }
    
    return nil
  }
}


// ----------------------------
//
// Percentile.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**

  Calculates Percentile value for the given dataset. This method is used same in Microsoft Excel (PERCENTILE or PERCENTILE.INC) and Google Docs Sheets (PERCENTILE). Same as the 7th sample quantile method from the Hyndman and Fan paper (1996).

  https://en.wikipedia.org/wiki/Percentile

  - parameter values: Array of decimal numbers in the dataset.
  - parameter percentile: percentile between 0 and 1 inclusive. For example, value 0.4 corresponds to 40th percentile.
  - returns: the percentile value.

  Algorithm:

  https://github.com/evgenyneu/SigmaSwiftStatistics/wiki/Percentile-1-method

  Example:

      Sigma.percentile1(values: [35, 20, 50, 40, 15], percentile: 0.4) // Result: 29

  */
  public static func percentile(values: [Double], percentile: Double) -> Double? {
    return Sigma.quantiles.method7(values, probability: percentile)
  }
}


// ----------------------------
//
// Quantiles.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 21/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//

import Foundation

public extension Sigma {
  /**
   
  The class contains nine functions that calculate sample quantiles corresponding to the given probability. The implementation is the same as in R. This is an implementation of the algorithms described in the Hyndman and Fan paper, 1996:
   
  https://www.jstor.org/stable/2684934
  https://www.amherst.edu/media/view/129116/original/Sample+Quantiles.pdf
   
  The documentation of the functions is based on R and Wikipedia:
   
  https://en.wikipedia.org/wiki/Quantile
  http://stat.ethz.ch/R-manual/R-devel/library/stats/html/quantile.html

  */
  public static let quantiles = SigmaQuantiles()
}

public class SigmaQuantiles {
  /*
  
  This method calculates quantiles using the inverse of the empirical distribution function.
  
  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.
   
  */
  public func method1(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let k = Int((probability * count))
    let g = (probability * count) - Double(k)
    var new_probability = 1.0
    if g == 0.0 { new_probability = 0.0 }
    return qDef(data, k: k, probability: new_probability)
  }
  
  /**
   
  This method uses inverted empirical distribution function with averaging.

  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.
   
  */
  public func method2(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let k = Int(probability * count)
    let g = (probability * count) - Double(k)
    var new_probability = 1.0
    if g == 0.0 { new_probability = 0.5 }
    return qDef(data, k: k, probability: new_probability)
  }
  
  /**
   
  The 3rd sample quantile method from Hyndman and Fan paper (1996).
   
  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.
   
  */
  public func method3(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = -0.5
    let k = Int((probability * count) + m)
    let g = (probability * count) + m - Double(k)
    var new_probability = 1.0
    if g <= 0 && k % 2 == 0 { new_probability = 0.0 }
    return qDef(data, k: k, probability: new_probability)
  }
  
  /**
   
  It uses linear interpolation of the empirical distribution function.

  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.
   
  */
  public func method4(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = 0.0
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**
   
  This method uses a piecewise linear function where the knots are the values midway through the steps of the empirical distribution function.

  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.

  */
  public func method5(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = 0.5
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**

  This method is implemented by Minitab and SPSS and uses linear interpolation of the expectations for the order statistics for the uniform distribution on [0,1].
   
  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.

  */
  public func method6(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = probability
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**
   
  This method is implemented in S, Microsoft Excel (PERCENTILE or PERCENTILE.INC) and Google Docs Sheets (PERCENTILE). It uses linear interpolation of the modes for the order statistics for the uniform distribution on [0, 1].

  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.

  */
  public func method7(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = 1.0 - probability
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**

  The quantiles returned by the method are approximately median-unbiased regardless of the distribution of x.


  - parameter data: Array of decimal numbers.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.

  */
  public func method8(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = (probability + 1.0) / 3.0
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**

  The quantiles returned by this method are approximately unbiased for the expected order statistics if x is normally distributed.
   
   - parameter data: Array of decimal numbers.
   - parameter probability: the probability value between 0 and 1, inclusive.
   - returns: sample quantile.
   
  */
  public func method9(_ data: [Double], probability: Double) -> Double? {
    if probability < 0 || probability > 1 { return nil }
    let data = data.sorted(by: <)
    let count = Double(data.count)
    let m = (0.25 * probability) + (3.0 / 8.0)
    let k = Int((probability * count) + m)
    let probability = (probability * count) + m - Double(k)
    return qDef(data, k: k, probability: probability)
  }
  
  /**
  
  Shared function for all quantile methods.

  - parameter data: Array of decimal numbers.
  - parameter k: the position of the element in the dataset.
  - parameter probability: the probability value between 0 and 1, inclusive.
  - returns: sample quantile.

  */
  private func qDef(_ data: [Double], k: Int, probability: Double) -> Double? {
    if data.isEmpty { return nil }
    if k < 1 { return data[0] }
    if k >= data.count { return data.last }
    return ((1.0 - probability) * data[k - 1]) + (probability * data[k])
  }
}


// ----------------------------
//
// Sigma.swift
//
// ----------------------------

import Foundation

/**

Collection of functions for statistical calculation.

Project home: https://github.com/evgenyneu/SigmaSwiftStatistics

*/
public struct Sigma {
  /**
  
  Calculates the maximum value in the array.

  - parameter values: Array of decimal numbers.
  - returns: The maximum value in the array. Returns nil for an empty array.

  Example:

      Sigma.max([3, 10, 6]) // 10
  
  */
  public static func max(_ values: [Double]) -> Double? {
    if let maxValue = values.max() {
      return maxValue
    }
    
    return nil
  }
  
  /**
  
  Calculates the mimimum value in the array.

  - parameter values: Array of decimal numbers.
  - returns: The mimimum value in the array. Returns nil for an empty array.
  
  Example:

      Sigma.min([5, 3, 10]) // -> 3

  */
  public static func min(_ values: [Double]) -> Double? {
    if let minValue = values.min() {
      return minValue
    }
    
    return nil
  }
  
  /**

  Computes the sum of array values.
  
  - parameter values: Array of decimal numbers.
  - returns: The sum of array values.

  Example:

      Sigma.sum([1, 3, 10]) // 14

  */
  public static func sum(_ values: [Double]) -> Double {
    return values.reduce(0, +)
  }
  
  /**
  
  Computes arithmetic mean of values in the array.
  
  http://en.wikipedia.org/wiki/Arithmetic_mean
  
  - parameter values: Array of decimal numbers.
  - returns: Arithmetic mean of values in the array. Returns nil for an empty array.

  Formula:

      A = Σ(x) / n
  
  Where n is the number of values.

  Example:

      Sigma.average([1, 12, 19.5, -5, 3, 8]) // 6.416666666666667

  */
  public static func average(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    return sum(values) / count
  }
  
  // MARK: - Protected functionality
  
  static func sort(_ values: [Double]) -> [Double] {
    return values.sorted { $0 < $1 }
  }
}


// ----------------------------
//
// Skewness.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 19/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//


import Foundation

public extension Sigma {
  /**
   
  Returns the skewness of the dataset. This implementation is the same as the SKEW function in Excel and Google Docs Sheets.
   
  https://en.wikipedia.org/wiki/Skewness
   
  - parameter values: Array of decimal numbers.
   
  - returns: Skewness based on a sample. Returns nil if the dataset contains less than 3 values. Returns nil if all the values in the dataset are the same.
   
  Formula (LaTeX):
   
      rac{n}{(n-1)(n-2)}\sum_{i=1}^{n} rac{(x_i - ar{x})^3}{s^3}
   
  Example:
   
      Sigma.skewnessA([4, 2.1, 8, 21, 1]) // 1.6994131524
   
  */
  public static func skewnessA(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count < 3 { return nil }
    guard let moment3 = centralMoment(values, order: 3) else { return nil }
    guard let stdDev = standardDeviationSample(values) else { return nil }
    if stdDev == 0 { return nil }
  
    return pow(count, 2) / ((count - 1) * (count - 2)) * moment3 / pow(stdDev, 3)
  }
  
  /**
 
  Returns the skewness of the dataset. This implementation is the same as in Wolfram Alpha, SKEW.P in Microsoft Excel and `skewness` function in "moments" R package..
   
  https://en.wikipedia.org/wiki/Skewness
   
  - parameter values: Array of decimal numbers.
   
  - returns: Skewness based on a sample. Returns nil if the dataset contains less than 3 values. Returns nil if all the values in the dataset are the same.
   
  Formula (LaTeX):
   
      rac{1}{n}\sum_{i=1}^{n} rac{(x_i - ar{x})^3}{\sigma^3}
   
   
  Example:
   
      Sigma.skewnessB([4, 2.1, 8, 21, 1]) // 1.1400009992
   
  */
  public static func skewnessB(_ values: [Double]) -> Double? {
    if values.count < 3 { return nil }
    guard let stdDev = standardDeviationPopulation(values) else { return nil }
    if stdDev == 0 { return nil }
    guard let moment3 = centralMoment(values, order: 3) else { return nil }
    
    return moment3 / pow(stdDev, 3)
  }
}


// ----------------------------
//
// StandardDeviation.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**
   
   Computes standard deviation based on a sample.
   
   http://en.wikipedia.org/wiki/Standard_deviation
   
   - parameter values: Array of decimal numbers.
   - returns: Standard deviation of a sample. Returns nil when the array is empty or contains a single value.
   
   Formula:
   
   s = sqrt( Σ( (x - m)^2 ) / (n - 1) )
   
   Where:
   
   m is the sample mean.
   
   n is the sample size.
   
   Example:
   
   Sigma.standardDeviationSample([1, 12, 19.5, -5, 3, 8]) // 8.674195447801869
   
   */
  public static func standardDeviationSample(_ values: [Double]) -> Double? {
    if let varianceSample = varianceSample(values) {
      return sqrt(varianceSample)
    }
    
    return nil
  }
  
  /**
   
   Computes standard deviation of entire population.
   
   http://en.wikipedia.org/wiki/Standard_deviation
   
   - parameter values: Array of decimal numbers.
   - returns: Standard deviation of entire population. Returns nil for an empty array.
   
   Formula:
   
   σ = sqrt( Σ( (x - m)^2 ) / n )
   
   Where:
   
   m is the population mean.
   
   n is the population size.
   
   Example:
   
   Sigma.standardDeviationPopulation([1, 12, 19.5, -5, 3, 8]) // 8.67419544780187
   
   */
  public static func standardDeviationPopulation(_ values: [Double]) -> Double? {
    if let variancePopulation = variancePopulation(values) {
      return sqrt(variancePopulation)
    }
    
    return nil
  }
}


// ----------------------------
//
// StandardErrorOfTheMean.swift
//
// ----------------------------

//
//  Created by Alan James Salmoni on 18/12/2016.
//  Copyright © 2016 Thought Into Design Ltd. All rights reserved.
//


import Foundation

public extension Sigma {
  /**

  Computes standard error of the mean.

  http://en.wikipedia.org/wiki/Standard_error

  - parameter values: Array of decimal numbers.
   
  - returns: Standard error of the mean. Returns nil when the array is empty or contains a single value.

  Formula:

      SE = s / sqrt(n)

  Where:

  s is the sample standard deviation.

  n is the sample size.

  Example:

      Sigma.standardErrorOfTheMean([1, 12, 19.5, -5, 3, 8]) // 3.5412254627

  */
  public static func standardErrorOfTheMean(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    guard let stdev = standardDeviationSample(values) else { return nil }
    return stdev / sqrt(count)
  }
}


// ----------------------------
//
// Variance.swift
//
// ----------------------------

import Foundation

public extension Sigma {
  /**
   
   Computes variance based on a sample.
   
   http://en.wikipedia.org/wiki/Variance
   
   - parameter values: Array of decimal numbers.
   - returns: Variance based on a sample. Returns nil when the array is empty or contains a single value.
   
   Formula:
   
   s^2 = Σ( (x - m)^2 ) / (n - 1)
   
   Where:
   
   m is the sample mean.
   
   n is the sample size.
   
   Example:
   
   Sigma.varianceSample([1, 12, 19.5, -5, 3, 8]) // 75.24166667
   
   */
  public static func varianceSample(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count < 2 { return nil }
    
    if let avgerageValue = average(values) {
      let numerator = values.reduce(0) { total, value in
        total + pow(avgerageValue - value, 2)
      }
      
      return numerator / (count - 1)
    }
    
    return nil
  }
  
  /**
   
   Computes variance of entire population.
   
   http://en.wikipedia.org/wiki/Variance
   
   - parameter values: Array of decimal numbers.
   - returns: Population variance. Returns nil when the array is empty.
   
   Formula:
   
   σ^2 = Σ( (x - m)^2 ) / n
   
   Where:
   
   m is the population mean.
   
   n is the population size.
   
   Example:
   
   Sigma.variancePopulation([1, 12, 19.5, -5, 3, 8]) // 62.70138889
   
   */
  public static func variancePopulation(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    
    if let avgerageValue = average(values) {
      let numerator = values.reduce(0) { total, value in
        total + pow(avgerageValue - value, 2)
      }
      
      return numerator / count
    }
    
    return nil
  }
}


