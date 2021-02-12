//MP3 simulation
//This file contains the Planet class.

//You should not change this file. Please use as is.

using System;

namespace SolarSystemSimulation
{
    public class Planet
    {
        readonly double GravitationalConstant = 6.673e-11;

        public double rx, ry;       // cartesian x and y position components
        public double vx, vy;       // velocity (projected to x and y) 
        public double fx, fy;       // force (projected to x and y)
        public double mass;         // mass

        /// <summary>
        /// Constructor to initialize the position, velocity and mass
        /// </summary>
        /// <param name="rx">x component of the position.</param>
        /// <param name="ry">y component of the position.</param>
        /// <param name="vx">x component of the velocity.</param>
        /// <param name="vy">y component of the velocity.</param>
        /// <param name="mass">The mass.</param>
        public Planet(double rx, double ry, double vx, double vy, double mass)
        {
            this.rx = rx;
            this.ry = ry;
            this.vx = vx;
            this.vy = vy;
            this.mass = mass;
        }

        /// <summary>
        /// Converts the planet's current info (position, velocity, mass) to string
        /// </summary>
        /// <returns>A string containing this planet's current info.</returns>
        public override string ToString()
        {
            return $"x = {rx,-12:G6}      y = {ry,-12:G6}";
        }

        /// <summary>
        /// Updates the velocity 
        /// </summary>
        /// <param name="dt_actual">The simulation dt used as the update interval.</param>
        public void UpdateVelocity(double dt_actual)
        {
            vx += dt_actual * fx / mass;
            vy += dt_actual * fy / mass;
        }
        /// <summary>
        /// Updates the position 
        /// </summary>
        /// <param name="dt_actual">The simulation dt used as the update interval.</param>
        public void UpdatePosition(double dt_actual)
        {
            rx += dt_actual * vx;
            ry += dt_actual * vy;
        }

        /// <summary>
        /// Updates the velocity and position
        /// </summary>
        /// <param name="dt_actual">The simulation dt used as the update interval.</param>
        public void UpdatePositionAndVelocity(double dt_actual)
        {
            UpdateVelocity(dt_actual);
            UpdatePosition(dt_actual);
        }

        /// <summary>
        /// Computes the force acting on this planet by another
        /// </summary>
        /// <param name="otherPlanet">The other planet.</param>
        public void ComputeForce(Planet otherPlanet)
        {
            double deltaX = otherPlanet.rx - this.rx;
            double deltaY = otherPlanet.ry - this.ry;
            double distance = Math.Sqrt(deltaX * deltaX + deltaY * deltaY);
            double force = GravitationalConstant * this.mass * otherPlanet.mass / (distance * distance);
            this.fx += force * deltaX / distance;
            this.fy += force * deltaY / distance;
        }
    }
} 
