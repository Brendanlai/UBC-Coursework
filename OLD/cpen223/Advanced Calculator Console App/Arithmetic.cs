//MP2 Calculator 
//This file contains the Arithmethic class.

//You should implement the requested method.

using System;
using System.Collections.Generic;

namespace MP2
{
    public class Arithmetic
    {
        /// <summary>
        /// Use this method as is.
        /// It is called by Main and is used to get an expression from console
        /// which is passed to the Calculate method.
        /// </summary>
        /// <returns>The formatted expression and the expression evaluation result</returns>
        public static string BasicArithmetic()
        {
            Console.WriteLine();
            Console.WriteLine("Basic arithmetic opertions with + - * / ^");
            Console.WriteLine("Enter an expression:");
            string expression = Console.ReadLine().Trim();

            return Calculate(expression);
        }

        /// <summary>
        /// Evaluates the arithmetic expression passed to it and 
        /// returns a nicly formatted expression (proper spaces etc) and 
        /// the result.
        /// The precedence of the operator is enforced only using parenthesis.
        /// </summary>
        /// <returns>
        /// Returns the string that contains the arithmetic expression and the result,
        /// or the requested error message. 
        /// If the expression is not valid, it returns "Invalid expression"
        /// </returns>
        /// <example>
        /// If the expression is "2.1 + 3" then the method returns "2.1 + 3 = 5.1".
        /// If the expression is "(2 + 3) * (2 ^ 5) it returns "( 2 + 3 ) * ( 2 ^ 5 ) = 160" 
        /// If the expression is "2 + ((3 * 2) * 5)" it returns "2 + ( ( 3 * 2 ) * 5 ) = 32" 
        /// Extra spaces are fine, so if the user enters "  2   ^ 3 " then 
        /// the method returns "2 ^ 3 = 8".
        /// If the user enters "4 5" or "4 +" or " (4 + 5" or "4 + 5 * 4)" i.e. any incorrect 
        /// or unbalanced expression, then the method returns "Invalid expression".
        /// </example>
        public static string Calculate(string expression)
        {
            // Check if valid expression or empty expressions entered
            if (!IsValidExpression(expression) || String.IsNullOrEmpty(expression))
            {
                return "Invalid expression";
            }

            string formattedExpression = FormatExpression(expression);

            // Get numerical result
            double result = GetResult(formattedExpression);

            // Add result to final expression
            string resultExpression = formattedExpression + " = " + result.ToString();

            // Add result to expression and return it
            return resultExpression;
        }

        /// <summary>
        /// Checks if user-inputted expression is valid.
        /// An expression is false if:
        /// i) Number of opened and closed brackets are not equal
        /// ii) Operator or signed operand is not followd by a space
        /// iii) Character in expression is not a digit, decimal operator (-,+,*,/,^), space or bracket
        /// iv) Decimal must be followed by a digit
        /// </summary>
        /// <param name="expression">User-inputted expresson to check.</param>
        /// <returns> 
        /// True if expression is valid and false otherwise.
        /// </returns>
        public static bool IsValidExpression(string expression)
        {
            char[] charArr = expression.ToCharArray();
            char c1, c2;

            int bracketCount = 0;
            bool isOperatorClosed = true;

            // Case of expression being one digit or char
            if (charArr.Length == 1 && !char.IsDigit(charArr[0]))
            {
                return false;
            }

            // Loop through expression
            for (int i = 0; i < charArr.Length - 1; i++)
            {

                c1 = charArr[i];
                c2 = charArr[i + 1];

                if (!char.IsDigit(c1) && !IsOperand(c1.ToString()) && c1 != ' ' && c1 != '(' && c1 != ')' && c1 != '.')
                {
                    return false;
                }

                // Check for invalid first paramters ), *, ^, / at index 0
                if (i == 0)
                {
                    if(c1 == ')' || c1 == '*' || c1 == '/' || c1 == '^')
                    {
                        return false;
                    }
                }

                // Make sure all operators are closed (have right sided number)
                if (IsOperand(c2.ToString()))
                {
                    isOperatorClosed = false;
                }
                else if (char.IsDigit(c2))
                {
                    isOperatorClosed = true;
                }


                // If char is a decimal, it must be followed by a digit
                if (c1 == '.' && !char.IsDigit(c2))
                {
                    return false;
                }

                // Digit must be followed by a space, another digit or a closing bracket
                if (char.IsDigit(c1) && (c2 != ' ' && c2 != ')' && !char.IsDigit(c2)))
                {
                    return false;
                }

                // Checks if operand has following space except +/- which may be followed by a digit
                // Checks if the following char is a unary operator
                if (IsOperand(c1.ToString()) && (c2 != ' ') && (c1 != '-' && c1 != '+' && !char.IsDigit(c2)))
                {
                    return false;
                }

                // Track # of opened and closed brackets
                if (c1 == '(')
                {
                    bracketCount++;
                }
                else if (c1 == ')')
                {
                    bracketCount--;
                }

                if (i == charArr.Length - 2)
                {
                    if (c2 == '(')
                    {
                        bracketCount++;
                    }
                    else if (c2 == ')')
                    {
                        bracketCount--;
                    }
                }

                if (bracketCount < 0)
                {
                    return false; // Checks to make sure there is never an un opened close bracket
                }

            }

            // Number of closed and open brackets must be equal for equation to be valid
            if (bracketCount != 0)
            {
                return false;
            }
            if (!isOperatorClosed)
            {
                return false;
            }

            return true;

        }

        /// <summary>
        /// Checks if character from expression is a valid operand.
        /// </summary>
        /// <param name="c">Character from user-entered expression to check.</param>
        /// <returns>
        /// True if char in expression is a +, -, *, / or ^. False otherwise. 
        /// </returns>
        public static bool IsOperand(string c)
        {
            return (c == "+" || c == "-" || c == "*" || c == "/" || c == "^");
        }

        /// <summary>
        /// Solves the entered user-inputted expression.
        /// </summary>
        /// <param name="expression">Expression to solve.</param>
        /// <returns>
        /// Numerical answer to the provided expression.
        /// </returns>
        public static double GetResult(string expression)
        {

            //Console.WriteLine(expression);

            List<string> expressionList = new List<string>();
            int firstIndex = 0;
            int secondIndex = 0;
            string operand;
            string firstOperator;
            string secondOperator;
            double result = 0;

            // Split expression in substrings using the spaces and add each substring to the list
            foreach (string str in expression.Split(' '))
            {
                expressionList.Add(str);
                //Console.WriteLine(str);
            }

            // While the expression list contains parantheses
            while (expressionList.Contains("("))
            {

                foreach (string str in expressionList)
                {
                    Console.Write($"{str} ");
                }
                Console.WriteLine();


                // Find the index of last open paranthesis
                for (int i = 0; i < expressionList.Count; i++)
                {
                    if (expressionList[i] == "(")
                    {
                        firstIndex = i;
                    }
                }

                // Find the index of the corresponding closing paranthesis
                for (int i = firstIndex; i < expressionList.Count; i++)
                {
                    if (expressionList[i] == ")")
                    {
                        secondIndex = i;
                        break;
                    }
                }

                Console.WriteLine($"First Index: {firstIndex}");
                Console.WriteLine($"Second Index: {secondIndex}");


                // If there is a single number in between parantheses
                if (secondIndex - firstIndex == 2)
                {
                    string loneOperator = expressionList[firstIndex + 1];

                    // Delete from the list all from firstIndex to lastIndex, inclusively
                    expressionList.RemoveRange(firstIndex, secondIndex - firstIndex + 1);

                    // Add the result to the first index in the list
                    expressionList.Insert(firstIndex, loneOperator);

                }
                else
                {
                    // Perform the operation that is in between the parentheses and save to result (minimum in a paranthesis is 3 substrings)
                    int subExpressionIndex = firstIndex;
                    int subLoop = 0;
                    double subResult = 0;

                    while (subExpressionIndex < secondIndex)
                    {
                        // If this is the first time around the loop, the first operator is immediately after the parenthesis
                        if (subLoop == 0)
                        {
                            firstOperator = expressionList[subExpressionIndex + 1];
                        }
                        // If not the first time, first operator should be the subResult calculates in the previous loop
                        else
                        {
                            firstOperator = subResult.ToString();
                        }

                        //Console.WriteLine($"First Operator: {firstOperator}");

                        operand = expressionList[subExpressionIndex + 2];
                        //Console.WriteLine($"Operand: {operand}");
                        secondOperator = expressionList[subExpressionIndex + 3];
                        //Console.WriteLine($"Second Operator: {secondOperator}");
                        subResult = Evaluate(firstOperator, operand, secondOperator);
                        //Console.WriteLine($"Sub Result: {subResult}");

                        // Increase sub expression index by 2 (next operand) and loop by 1
                        subExpressionIndex += 4;
                        subLoop++;
                    }

                    // Delete from the list all from firstIndex to lastIndex, inclusively
                    expressionList.RemoveRange(firstIndex, secondIndex - firstIndex + 1);

                    // Add the result to the first index in the list
                    expressionList.Insert(firstIndex, subResult.ToString());
                }
            }


            foreach (string str in expressionList)
            {
                Console.Write($"{str} ");
            }
            Console.WriteLine();

            Console.WriteLine($"This many strings left in list: {expressionList.Count}");

            // If there is not only one string in the list, perform all the operations remaining (not in parentheses)
            if (expressionList.Count != 1)
            {
                /*
                foreach (string str in expressionList)
                {
                    Console.Write($"{str} ");
                }
                Console.WriteLine();
                */

                int expressionIndex = 0;
                int loop = 0;
                while (expressionIndex < expressionList.Count - 2)
                {
                    // If this is the first time around the loop, the first operator is the first in the list
                    if (loop == 0)
                    {
                        firstOperator = expressionList[expressionIndex];
                    }
                    // If not the first time, first operator should be the subResult calculates in the previous loop
                    else
                    {
                        firstOperator = result.ToString();
                    }

                    Console.WriteLine($"First Operator: {firstOperator}");

                    operand = expressionList[expressionIndex + 1];
                    Console.WriteLine($"Operand: {operand}");
                    secondOperator = expressionList[expressionIndex + 2];
                    Console.WriteLine($"Second Operator: {secondOperator}");
                    result = Evaluate(firstOperator, operand, secondOperator);
                    Console.WriteLine($"Result: {result}");

                    expressionIndex += 2;
                    loop++;
                }
            }
            // If there is just one expression in the list, convert it to double to return it
            else
            {
                Console.WriteLine($"Converting to double: {expressionList[0]}");
                result = Convert.ToDouble(expressionList[0]);
            }

            return result;
        }

        /// <summary>
        /// Evaluate simple sub-expression (two operands and one operator) 
        /// from user-inputted expression.
        /// Used as a helper method for GetResult.
        /// </summary>
        /// <param name="leftOperand">Left value in sub-expression.</param>
        /// <param name="leftSign">Sign of left value in sub-expression.</param>
        /// <param name="op">Operator to perform calculation with</param>
        /// <param name="rightOperand">Right value in sub-expression.</param>
        /// <param name="rightSign">Sign of right value in sub-expression.</param>
        /// <returns>
        /// Numerical result of simple sub-expression as type double.
        /// </returns>
        /// <exception cref="System.DivideByZeroException">
        /// Thrown when right operand in simple sub-expression attmepts to divide by zero.
        /// </exception>
        public static double Evaluate(string leftOperand, string op, string rightOperand)
        {
            double result = 0;


            // Identify the correct operand, parse all strings to double and multiply by corresponding sign to evaluate
            if (op == "+")
            {
                result = (double.Parse(leftOperand)) + (double.Parse(rightOperand));
            }
            else if (op == "-")
            {
                result = (double.Parse(leftOperand)) - (double.Parse(rightOperand));
            }
            else if (op == "/")
            {
                // Exception thrown if user attempts to divide by zero in expression
                if (double.Parse(rightOperand) == 0)
                {
                    throw new DivideByZeroException("Cannot divide by zero in expression.");
                }

                result = (double.Parse(leftOperand)) / (double.Parse(rightOperand));
            }
            else if (op == "*")
            {
                result = (double.Parse(leftOperand)) * (double.Parse(rightOperand));
            }
            else if (op == "^")
            {
                result = Math.Pow((double.Parse(leftOperand)), (double.Parse(rightOperand)));
            }

            return result; // Returns numerical result as double
        }

        /// <summary>
        /// Removes all extra spaces in user inputted-expression
        /// </summary>
        /// <param name="expression">Expression to trim extra spaces and format.</param>
        /// <returns>
        /// string expression with each number, operator and bracket seperated by a space.
        /// </returns>
        public static string FormatExpression(string expression)
        {
            // Remove all spaces
            string trimmedExpression = expression.Replace(" ", string.Empty);

            string formattedExpression = "";
            char c;

            for (int i = 0; i < trimmedExpression.Length; i++)
            {
                c = trimmedExpression[i];

                // Statement only occurs once at the start of the loop
                if (i == 0)
                {
                    // If the first index is an operand, it is a sign
                    if (IsOperand(c.ToString()))
                    {
                        formattedExpression += c; // Don't add space for sign
                    }
                    else
                    {
                        // Only add space if next char is not a digit
                        if (char.IsDigit(trimmedExpression[i]) && char.IsDigit(trimmedExpression[i + 1]))
                        {
                            formattedExpression += c;
                        }
                        else
                        {
                            // Anything else than a sign can be spaced
                            formattedExpression += c;
                            formattedExpression += ' ';
                        }
                    }
                }
                // Ensure there is no overflow - enters when index > 0
                else if (i != trimmedExpression.Length - 1)
                {
                    // If char is a bracket it can be added/spaced
                    if (c == '(' || c == ')')
                    {
                        formattedExpression += c;
                        formattedExpression += ' ';
                    }
                    else if (char.IsDigit(c))
                    {
                        formattedExpression += c;

                        // Only add space if next char is not a digit
                        if (!char.IsDigit(trimmedExpression[i + 1]))
                        {
                            formattedExpression += ' ';
                        }
                    }
                    else if (IsOperand(c.ToString()))
                    {

                        // If Operand has an open bracket to the left and digit to the write it is a sign
                        if (trimmedExpression[i - 1] == '(' && char.IsDigit(trimmedExpression[i + 1]))
                        {
                            // Don't space signs
                            formattedExpression += c;
                        }
                        // If Operand has another operand to the left and digit to the write it is a sign
                        else if (IsOperand(trimmedExpression[i - 1].ToString()) && char.IsDigit(trimmedExpression[i + 1]))
                        {
                            // Don't space signs
                            formattedExpression += c;
                        }
                        // All other cases are operands space regularily
                        else
                        {
                            formattedExpression += c;
                            formattedExpression += ' ';
                        }
                    }
                }
                // Last char in expression, no need to have a space following
                else
                {
                    formattedExpression += c;
                }

            }

            // Formatted expression            
            return formattedExpression; // Good
        }
    }
}

