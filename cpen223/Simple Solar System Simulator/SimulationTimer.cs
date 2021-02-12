//MP3 SimulationTimer (console app version)  
//This file contains the SimulatorTimer class. It uses the System.Timers.Timer 
//class to create the timed events for updates.

//Complete the requested methods. Do not add any new using directive, methods, or fields.

using System;

namespace SolarSystemSimulation
{
    public class SimulationTimer
    {
        System.Timers.Timer timer;
        double simulationTime = 0;
        int simulationTimeInterval; //The simulation dt provided by the user
        PlanetarySystem nPlanetsAndSun;
        int duration = 0; //The simulation duration

        /// <summary>
        /// creates and starts a timer. The timer ticks once every simulationTimeInterval to update simulation
        /// </summary>
        /// <param name="nPlanetsAndSun">The current planetary system to simulate.</param>
        /// <param name="duration">The simulation duration in ms.</param>
        /// <param name="simulationTimeInterval">The simulation time interval (dt).</param>
        public void SetTimer(PlanetarySystem nPlanetsAndSun, int duration, int simulationTimeInterval)
        {
            this.simulationTimeInterval = simulationTimeInterval; //milliseconds (dt provided by the user)

            timer = new System.Timers.Timer(simulationTimeInterval); //Create a timer
            timer.Elapsed += UpdatePlanetsAndSimulationTime; //Sets which method to call when timer elapses
            timer.Enabled = true;
            timer.Start();

            this.nPlanetsAndSun = nPlanetsAndSun;
            this.duration = duration; //milliseconds
        }

        /// <summary>
        /// This method is called every simulationTimeInterval when the simulation is running. 
        /// It must perform all necessary simulation updates.
        /// (A method for the timer event delagate: used for the discrete event simulation updates).
        /// </summary>
        private void UpdatePlanetsAndSimulationTime(Object source, System.Timers.ElapsedEventArgs e)
        {
            // Update the simulation time and the planet status'
            simulationTime += simulationTimeInterval;
            nPlanetsAndSun.UpdateAll();

            // If end of the simulation, reset simulation time to 0 and dispose of the current timer
            if (simulationTime >= simulationTimeInterval * duration)
            {
                timer.Close();
            }
        }

        /// <summary>
        /// Gets the current simulation time
        /// </summary>
        /// <returns>Simulation time (not the real time)</returns>
        public double GetSimulationTime()
        {
            return simulationTime;
        }

        /// <summary>
        /// Pauses the simulation timer
        /// </summary>
        public void Pause()
        {
            timer.Stop();
        }

        /// <summary>
        /// Resumes the simulation timer
        /// </summary>
        public void Resume()
        {
            timer.Start();
        }

        /// <summary>
        /// Gets the simulation duration (number of events)
        /// </summary>
        /// <returns>The field duration</returns>
        public double GetDuration()
        {
            return duration;
        }
    }
}
