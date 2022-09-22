//MP3 Main (console app version)  
//This file contains the SimulatorMain with the Main method for the program.

//Complete the Main method. Do not add any new using directive, methods, or fields.

using System;

namespace SolarSystemSimulation
{
    class SimulatorMain
    {
        public static void Main()
        {
            PlanetarySystem planets = new PlanetarySystem(0);
            SimulationTimer timer = new SimulationTimer();
            bool running = false; //set to true when a simulation is running
            bool paused = false; //set to true when a simulation is paused
            bool planetarySystemExists = false; //set to true when PlantarySystem is created

            Console.WriteLine("Welcome to the solar planet simulator! Select from the menu.");

            while (true)
            {
                Console.WriteLine();
                Console.Write("(s)tart, (p)ause, (r)esume, (g)et status, (q)uit? "); 

                string choice;

                try
                {
                    choice = Console.ReadLine().Trim().ToLower();
                }
                catch (System.IO.IOException e)
                {
                    Console.WriteLine($"IO Exception: {e.Message}");
                    continue;
                }

                // time variables for calculating duraiton and verifying is running
                int dtInt = 0;
                int durationInt = 0;

                string result = "Please choose from the menu";

                if (choice.StartsWith("s"))
                {
                    // Reset flags (in case somebody wants to create another simulation
                    running = false;
                    paused = false;
                    
                    int numberInt;

                    // If no simulation is currently running, ask for number of planets
                    if (!running)
                    {
                        Console.WriteLine();
                        Console.Write("How many planets (1 to 9) [In addition to the Sun]? ");

                        // If entered number of planets is valid, ask for simulation dt
                        if (GetInt(out numberInt, 1, 9, ref result))
                        {              
                            Console.Write("Simulation dt (ms) [1 to 1000]? (1 simulation dt (ms) = 1 day of actual time) ");

                            // If simulation dt time is valid, ask for the simulation duration
                            if (GetInt(out dtInt, 1, 1000, ref result))
                            {
                                Console.Write("Simulation duration (how many dt's) [1 to 1000] ");

                                // If duration time is valid, initiate simulation
                                if (GetInt(out durationInt, 1, 1000, ref result))
                                {
                                    // Initialize the planetary system with 3 planets
                                    planets = new PlanetarySystem(numberInt);

                                    // Create new timer (if 2 sims in a row) and set the timer to the entered duration and dt
                                    timer = new SimulationTimer();
                                    timer.SetTimer(planets, durationInt, dtInt);

                                    // Set the running flag to true
                                    running = true;
                                    planetarySystemExists = true;

                                    // Print confirmation message to user
                                    result = $"A simulation of {numberInt} planets initiated.";
                                }
                            }
                        }
                    }
                }
                else if (choice.StartsWith("p"))
                {
                    // If no simulation is running, print message
                    if (!running)
                    {
                        result = "No simulation is running to be paused.";
                    }
                    // Else if the simulation is already paused, print message to user
                    else if (paused)
                    {
                        result = "Already paused.";
                    }
                    else
                    {
                        // Pause the timer and set paused flag to true
                        timer.Pause();
                        paused = true;

                        // Print confirmation message to user
                        result = "Simulation paused.";
                    }
                }
                else if (choice.StartsWith("r"))
                {
                    // If no simulation is running, print message
                    if (!running)
                    {
                        result = "No simulation is running to be resumed.";
                    }
                    // Else if the simulation is not paused, print message to user
                    // Else if the simulation is not paused, print message to user
                    else if (!paused)
                    {
                        result = "No simulation is paused to be resumed.";
                    }
                    // Else, resume the simulation and set paused flag to false 
                    else
                    {
                        // Pause the timer and set paused flag to true
                        timer.Resume();
                        paused = false;

                        // Print confirmation message to user
                        result = "Simulation resumed.";
                    }
                }
                else if (choice.StartsWith("g"))
                {
                    // If no simulation is running, print message
                    if (!planetarySystemExists)
                    {
                        result = "No simulation is running.";
                    }
                    else
                    {
                        // Print out the current simulation time and current state of the planets
                        string time = $"At time: {timer.GetSimulationTime()}\n";
                        planets.GetCurrentState(out result);

                        result = time + result;
                    }
                }
                else if (choice.StartsWith("q"))
                {
                    // Exit superloop
                    break;
                }

                // Assign running is true if it is larger than the duration and planetarysystemexists
                running = (dtInt * durationInt >= timer.GetDuration() && planetarySystemExists);

                Console.WriteLine();
                // Result string to print is updated in one of the conditional statements
                Console.WriteLine(result);
            }
        }

        /// <summary>
        /// Gets an int from the command line within the range [min, max]. 
        /// If the provided num is not acceptable, str will contain an error message.
        /// </summary>
        /// <param name="num">Nummber received from the user and returned through the out argument.</param>
        /// <param name="min">Min acceptable range for num.</param>
        /// <param name="max">Max acceptable range for num.</param>
        /// <param name="str">Contains an error message if not successful.</param>
        /// <returns>true if successful, false otherwise.</returns>
        private static bool GetInt(out int num, int min, int max, ref string str)
        {
            if (int.TryParse(Console.ReadLine().Trim(), out num))
            {
                if (num >= min && num <= max)
                {
                    return true;
                }
                str = "Number outside range";
            }
            else
            {
                str = "Not an acceptable number";
            }
            return false;
        }
    }
}
