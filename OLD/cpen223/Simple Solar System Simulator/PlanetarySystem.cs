//MP3 simulation
//This file contains the PlanetarySystem class.

//You should not change this file. Please use as is.

using System;
using System.Collections.Generic;

namespace SolarSystemSimulation
{
    public class PlanetarySystem
    {
        readonly double GravitationalConstant = 6.673e-11;

        public int numOfPlanetsPlusSun = 0; //Number of planets plus Sun used in a simulation
        
        public List<Planet> planets; //List of planets used in a simulation
        readonly string[] planetNames = { "Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto" }; //Sun is also included
        
        readonly double dt_actual = 86400; //Actual time interval per simulation tick (86400 s = 1 day)

        readonly double solarmass = 1.98847e30; //kg (https://en.wikipedia.org/wiki/Solar_mass)
       
        /// <summary>
        /// Constructor for a solar system
        /// </summary>
        /// <param name="n">Number of planets in the system.</param>
        public PlanetarySystem(int n)
        {
            if (n == 0) //A replacement for the default constuctor
            {
                return;
            }
            if( n < 1 || n > 9) //Does nothing if invalid number of planets (Main should take care of this anyway)
            {
                return;
            }
            numOfPlanetsPlusSun = n + 1; //plus 1 to include the Sun
            planets = new List<Planet>();
            CreateSolarSystem(); //Initiaize the solar system for n planets plus Sun
        }

        /// <summary>
        /// Provides the current info for all planets in the system as a string
        /// The method uses the ToString method of the Planet class.
        /// </summary>
        /// <param name="result">An out argument used to provide the planets' info.</param>
        public void GetCurrentState(out string result)
        {
            result = string.Empty;
            int count = 0;
            foreach (var item in planets)
            {
                result += $"{planetNames[count],-9} {item.ToString()}\n";
                count++;
            }
        }

        /// <summary>
        /// Initializes the solar system 
        /// The system will have this.numOfPlanets planets in the system.
        /// </summary>
        public void CreateSolarSystem()
        {
            planets.Clear(); //not needed but for future changeability

            double[] planetaryDistanceFromSun = //km (https://nssdc.gsfc.nasa.gov/planetary/factsheet/)
            {
                0,        //Sun
                57.9e6,   //Mercury 
                108.2e6,  //Venus
                149.6e6,  //Earth
                227.9e6,  //Mars
                778.6e6,  //Jupiter
                1433.5e6, //Saturn
                2872.5e6, //Uranus
                4495.1e6, //Neptune
                5906.4e6  //Pluto
            };
            double universeRadius = planetaryDistanceFromSun[numOfPlanetsPlusSun-1] * 1.5; //A bit further out from the last planet's orbit

            double[] planetaryMass = //kg (https://en.wikipedia.org/wiki/Planetary_mass)
            {
                solarmass, //Sun  
                3.301e23,  //Mercury 
                4.867e24,  //Venus
                6.046e24,  //Earth
                6.417e23,  //Mars
                1.899e27,  //Jupiter
                5.685e26,  //Saturn
                8.682e25,  //Uranus
                1.024e26,  //Neptune
                1.471e22   //Pluto
            };


            //Put the Sun at the centre of our simulated universe
            planets.Add(new Planet(0, 0, 0, 0, solarmass));

            //Initialize all planets: Initially all planets are put on the x axis
            for (int i = 1; i < numOfPlanetsPlusSun; i++)
            {
                double x = planetaryDistanceFromSun[i];
                double y = 0;
                //Although y is set to zero, full formulas are used below for future changeability
                double V = Math.Sqrt(GravitationalConstant * (solarmass + planetaryMass[i]) / Math.Sqrt(x * x + y * y));
                double vx = -1 * Math.Sign(y) * Math.Cos(Math.PI / 2 - Math.Atan(Math.Abs(y / x))) * V;
                double vy = Math.Sign(x) * Math.Sin(Math.PI / 2 - Math.Atan(Math.Abs(y / x))) * V;

                planets.Add(new Planet(x, y, vx, vy, planetaryMass[i]));
            }
        }

        /// <summary>
        /// Computes new forces for each planet, and causes updates 
        /// </summary>
        public void UpdateAll()
        {
            //A side note: this algorithm has an N^2 complexity due to nested loop
            for (int i = 1; i < numOfPlanetsPlusSun; i++) //excluding the Sun
            {
                planets[i].fx = 0; //Reset fx for a new calculation
                planets[i].fy = 0; //Reset fy for a new calculation
                for (int j = 0; j < numOfPlanetsPlusSun; j++) //including the Sun for the pairwise force calcualtions
                {
                    if (i != j) //Exclude self 
                    { 
                        planets[i].ComputeForce(planets[j]); 
                    }
                }
            }
            //Having all pair-wise forces computed, update the position and velocity of each planet
            for (int i = 1; i < numOfPlanetsPlusSun; i++)
            {
                planets[i].UpdatePositionAndVelocity(dt_actual);
            }
        }
    }
} 
