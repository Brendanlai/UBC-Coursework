//MP2 Calculator 
//This file contains the CalculusCalculator class.

//You should implement the requesed methods.

using System;
using System.Collections.Generic;
using System.Text;

namespace MP2
{
    public class Calculus
    {
        List<double> coefficientList = new List<double>(); //the only field of this class

        /// <summary>
        /// Default constructor for the Calculus class
        /// Does not initialize the coefficientList
        /// </summary>
        public Calculus()
        {

        }

        /// <summary>
        /// Overloaded constructor for the calculus
        /// Takes in the provided list of parameters and initializes the coefficientList field with it
        /// </summary>
        /// <param name="coefficients">List of provided coefficients</param>
        public Calculus(List<double> coefficients)
        {
            coefficientList = coefficients;
        }

        /// <summary>
        /// Prompts the user for the coefficients of a polynomial, and sets the 
        /// the coefficientList field of the object.
        /// The isValidPolynomial method is used to check for the validity
        /// of the polynomial entered by the user, otherwise the field must 
        /// not change.
        /// The acceptable format of the coefficients received from the user is 
        /// a series of numbers (one for each coefficient) separated by spaces. 
        /// All coefficients values must be entered even those that are zero.
        /// </summary>
        /// <returns>True if the polynomial is succeffully set, false otherwise.</returns>
        public bool SetPolynomial()
        {
            // Get user input
            Console.WriteLine();
            Console.Write("Please enter the polynomial coefficients separated by a space: ");
            string inputStr = Console.ReadLine();

            // Check if input string is valid
            if (IsValidPolynomial(inputStr))
            {
                // Convert input string to char array for parsing
                char[] inputArr = inputStr.ToCharArray();
                int charIndex = 0;
                coefficientList.Clear();

                // While we haven't gotten to the end of the array
                while (charIndex < inputArr.Length)
                {
                    char character = inputArr[charIndex];

                    // If the current character is a digit or a minus sign
                    if (char.IsDigit(character) || character == '-')
                    {
                        // Create stringbuilder object to add digits
                        StringBuilder coefficient = new StringBuilder();

                        // While the characters are a digit or a ., add them to the stringbuilder and increase charIndex
                        while (char.IsDigit(character) || character == '.')
                        {
                            coefficient.Append(character);
                            charIndex++;

                            if (charIndex >= inputArr.Length)
                            {
                                break;
                            }

                            character = inputArr[charIndex];
                        }

                        // Convert the stringbuilder to a string, then a double, then add to coefficientList
                        coefficientList.Add(Convert.ToDouble(coefficient.ToString()));

                        charIndex++;
                    }
                    else
                    {
                        // If character is not a digit or a -, increase index by 1
                        charIndex++;
                    }
                }

                // Return true when input string is valid and coefficients have been added to list
                return true;
            }
            else
            {
                // Return false if input string was not valid
                return false;
            }
        }

        /// <summary>
        /// Checks if the passed polynomial string is valid.
        /// The acceptable format of the coefficient string is a series of 
        /// numbers (one for each coefficient) separated by spaces. 
        /// </summary>
        /// <example>
        /// Examples of valid strings: "2   3.5 0  ", or "-2 -3.5 0 0"
        /// Examples of invalid strings: "3..5", or "2x^2+1", or "a b c", or "3 - 5"
        /// </example>
        /// <param name="polynomial">
        /// A string containing the coefficient of a polynomial. The first value is the
        /// highest order, and all coefficients exist (even 0's).
        /// </param>
        /// <returns>True if a valid polynomial, false otherwise.</returns>
        public bool IsValidPolynomial(string polynomial)
        {
            char[] charArr = polynomial.ToCharArray();

            // Do a first pass to see if there are non-allowed characters
            foreach (char c in charArr)
            {
                if (!char.IsDigit(c) && c != '.' && c != '-' && c != ' ')
                {
                    return false;
                }
            }

            int charIndex = 0;
            // While we haven't gotten to the end of the array
            while (charIndex < charArr.Length)
            {
                char character = charArr[charIndex];
                // If the character is a digit or a minus sign, this marks a possible double 
                if (char.IsDigit(character) || character == '-')
                {
                    // Set the start index of the double and length of the possible double to 0
                    int start = charIndex;
                    int length = 0;

                    // While the character is not a whitespace or is not the last character, increase the index and the length
                    while (!char.IsWhiteSpace(character) && charIndex != charArr.Length)
                    {
                        character = charArr[charIndex];
                        charIndex++;
                        length++;
                    }

                    // Create an array for the characters of the possible double, copy the characters to it, and convert to string
                    char[] possibleDouble = new char[length];
                    Array.Copy(charArr, start, possibleDouble, 0, length);
                    string doubleStr = new string(possibleDouble);

                    // Check if the string created converts to double. If not, return false
                    double coefficient;
                    if (!Double.TryParse(doubleStr, out coefficient))
                    {
                        return false;
                    }
                }
                else
                {
                    charIndex++;
                }
            }
            // If we get through the entire array and we only find valid doubles, return true
            return true;
        }

        /// <summary>
        /// Returns a string representing this polynomial.
        /// </summary>
        /// <returns>
        /// A string containing the polynomial in the format:
        /// (a_n)*x^n + (a_n_1)*x^n_1 + ... + (a1)*x + (a0) 
        /// Note that for simplicity, each coefficient is surrounded by 
        /// parenthesis (for us to easily consider negative coefficients too).
        /// It does not display the term of any coefficient that is 0.
        /// If all coefficients are 0, then it returns "0".
        /// </returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the coefficientList field is empty. 
        /// Exception message used: "No polynomial is set."
        /// </exception>
        public string GetPolynomial()
        {
            // Check if list is empty
            if (coefficientList.Count == 0)
            {
                throw new InvalidOperationException("No polynomial is set.");
            }

            // Create StringBuilder for the polynomial string
            StringBuilder polynomial = new StringBuilder();

            // Get the order of the polynomial
            int polyOrder = coefficientList.Count - 1;

            // Parse through the coefficient list
            for (int i = 0; i < coefficientList.Count; i++)
            {
                // Append proper string format to StringBuilder depending on term power
                if (polyOrder != 0 && polyOrder != 1 && coefficientList[i] != 0)
                {
                    // Append without plus sign if this is our highest order term
                    if (i != 0)
                    {
                        polynomial.Append($" + ({coefficientList[i]})*x^{polyOrder} + ");
                    }
                    else
                    {
                        polynomial.Append($"({coefficientList[i]})*x^{polyOrder}");
                    }
                }
                else if (polyOrder == 1 && coefficientList[i] != 0)
                {
                    polynomial.Append($" ({coefficientList[i]})*x + ");
                }
                else if (polyOrder == 0 && coefficientList[i] != 0)
                {
                    polynomial.Append($"({coefficientList[i]})");

                }

                polyOrder--; // Decrement polynomial order
            }

            if (polynomial.ToString().Length == 0) return "0";

            // Return stringbuilder converted to string
            return polynomial.ToString();
        }

        /// <summary>
        /// Evaluates this polynomial at the x passed to the method.
        /// </summary>
        /// <param name="x">The x at which we are evaluating the polynomial.</param>
        /// <returns>The result of the polynomial evaluation.</returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the coefficientList field is empty. 
        /// Exception message used: "No polynomial is set."
        /// </exception>
        public double EvaluatePolynomial(double x)
        {
            // Check if list is empty
            if (coefficientList.Count == 0)
            {
                throw new InvalidOperationException("No polynomial is set.");
            }
            else
            {
                // Get polynomial order
                int polyOrder = coefficientList.Count - 1;

                // Create sum variable to add to
                double sum = 0;

                // For each coefficient in the list, add its polynomial expansion term
                for (int i = 0; i < coefficientList.Count; i++)
                {
                    // Compute the order of that specific term
                    int termOrder = polyOrder - i;

                    // Add is expansion to the sum
                    sum += coefficientList[i] * Math.Pow(x, termOrder);
                }

                // Return the sum
                return sum;
            }
        }

        /// <summary>
        /// Finds a root of this polynomial using the provided guess.
        /// </summary>
        /// <param name="guess">The initial value for the Newton method.</param>
        /// <param name="epsilon">The desired accuracy: stops when |f(result)| is
        /// less than or equal epsilon.</param>
        /// <param name="iterationMax">A max cap on the number of iterations in the
        /// Newton-Raphson method. This is to also guarantee no infinite loops.
        /// If this iterationMax is reached, a double.NaN is returned.</param>
        /// <returns>
        /// The root found using the Netwon-Raphson method. 
        /// A double.NaN is returned if a root cannot be found.
        /// The return value is rounded to have 4 digits after the decimal point.
        /// </returns>
        public double NewtonRaphson(double guess, double epsilon, int iterationMax)
        {
            int count = 0;
            double x = guess;

            while (Math.Abs(EvaluatePolynomial(x)) > epsilon && count < iterationMax)
            {
                x = x - EvaluatePolynomial(x) / EvaluatePolynomialDerivative(x);
                count++;
            }

            if (count == iterationMax || double.IsInfinity(x))
            {
                return double.NaN;
            }

            return Math.Round(x, 4); //4 decimal places
        }

        /// <summary>
        /// Calculates and returns all unique real roots of this polynomial 
        /// that can be found using the NewtonRaphson method. 
        /// The method uses all initial guesses between -50 and 50 with 
        /// steps of 0.5 to find all unique roots it can find. 
        /// A root is considered unique, if there is no root already found 
        /// that is within an accuracy level of 0.001 (since we rounded the roots).
        /// Uses 10 as the max number of iterations used by Newton-Raphson method.
        /// </summary>
        /// <param name="epsilon">The desired accuracy.</param>
        /// <returns>A list containing all the unique roots that the method finds.</returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the coefficientList field is empty. 
        /// Exception message used: "No polynomial is set."
        /// </exception>
        public List<double> GetAllRoots(double epsilon)
        {
            // Check if list is empty
            if (coefficientList.Count == 0)
            {
                throw new InvalidOperationException("No polynomial is set.");
            }
            else
            {
                // Create list to store the roots
                List<double> rootsList = new List<double>();

                // Define max iteration
                int iterationMax = 10;

                // For every guess between -50 and 50, with intervals of 0.5
                for (double guess = -50; guess <= 50; guess += 0.5)
                {
                    // Evaluate the root using NewtonRaphson
                    double root = NewtonRaphson(guess, epsilon, iterationMax);

                    // If the return value is not NaN and is not already in the list, then add to the list
                    if (!double.IsNaN(root) && !rootsList.Contains(root))
                    {
                        rootsList.Add(root);
                    }
                }

                // Return the list of roots
                return rootsList;
            }
        }

        /// <summary>
        /// Evaluates the 1st derivative of this polynomial at x, passed to the method.
        /// The method uses the exact numerical technique, since it is easy to obtain the 
        /// derivative of a polynomial.
        /// </summary>
        /// <param name="x">The x at which we are evaluating the polynomial derivative.</param>
        /// <returns>The result of the polynomial derivative evaluation.</returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the coefficientList field is empty.
        /// Exception message used: "No polynomial is set."
        /// </exception>
        public double EvaluatePolynomialDerivative(double x)
        {
            // Check if list is empty
            if (coefficientList.Count == 0)
            {
                throw new InvalidOperationException("No polynomial is set.");
            }
            else
            {
                // Get polynomial order
                int polyOrder = coefficientList.Count - 1;

                // Create sum variable to add to
                double sum = 0;

                // For each coefficient in the list, add the derivative evaluated at x to sum
                for (int i = 0; i < coefficientList.Count; i++)
                {
                    // Compute the order of that specific term
                    int termOrder = polyOrder - i;

                    // Since the term with order 0 (constant) disappears during derivation, skip it
                    if (termOrder != 0)
                    {
                        // Add its derivative expansion to the sum
                        sum += coefficientList[i] * termOrder * Math.Pow(x, termOrder - 1);
                    }
                }

                // Return the sum
                return sum;
            }
        }

        /// <summary>
        /// Evaluates the definite integral of this polynomial from a to b.
        /// The method uses the exact numerical technique, since it is easy to obtain the 
        /// indefinite integral of a polynomial.
        /// </summary>
        /// <param name="a">The lower limit of the integral.</param>
        /// <param name="b">The upper limit of the integral.</param>
        /// <returns>The result of the integral evaluation.</returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the coefficientList field is empty.
        /// Exception message used: "No polynomial is set."
        /// </exception>
        public double EvaluatePolynomialIntegral(double a, double b)
        {
            // Check if list is empty
            if (coefficientList.Count == 0)
            {
                throw new InvalidOperationException("No polynomial is set.");
            }
            else
            {
                // Get polynomial order
                int polyOrder = coefficientList.Count - 1;

                // Create sum variable to add to
                double sum = 0;

                // For each coefficient in the list, add the integrated coefficient and the difference of a and b raised to order +1
                for (int i = 0; i < coefficientList.Count; i++)
                {
                    // Compute the order of that specific term
                    int termOrder = polyOrder - i;

                    // Add its integral expansion to the sum
                    sum += (coefficientList[i] / (termOrder + 1)) * (Math.Pow(b, termOrder + 1) - Math.Pow(a, termOrder + 1));
                }

                // Return the sum
                return sum;
            }
        }
    }
}
