// -------------------------------------------------------------------------------------------------
// <copyright file="ConfigurationException.cs" company="Prisma">
//   Baufest(c) 2016
// </copyright>
// <summary>
//   Provides a configuration exception
// </summary>
// -------------------

namespace Adapter
{
    using System;

    /// <summary>
    /// This exception represents a configuration exception.
    /// </summary>
    public class ConfigurationException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ConfigurationException"/> class. 
        /// </summary>
        /// <param name="message">
        /// The configuration error message
        /// </param>
        public ConfigurationException(string message) : base(message)
        {
        }
    }
}