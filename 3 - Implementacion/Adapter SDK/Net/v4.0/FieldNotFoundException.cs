// -------------------------------------------------------------------------------------------------
// <copyright file="FieldNotFoundException.cs" company="Prisma">
//   Baufest(c) 2016
// </copyright>
// <summary>
//   Provides a field mapping exception
// </summary>
// -------------------

namespace Adapter
{
    using System;

    /// <summary>
    /// This exception represents a Parameter exception.
    /// </summary>
    public class FieldNotFoundException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FieldNotFoundException"/> class. 
        /// </summary>
        /// <param name="message">
        /// The FieldNotFoundException error message
        /// </param>
        public FieldNotFoundException(string message) : base(message)
        {
        }
    }
}