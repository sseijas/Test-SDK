// -------------------------------------------------------------------------------------------------
// <copyright file="NoResponseKeyException.cs" company="Prisma">
//   Baufest(c) 2016
// </copyright>
// <summary>
//   Provides a no key response exception
// </summary>
// -------------------

namespace Adapter
{
    using System;
    using System.Collections.Generic;

    /// <summary>
    /// This exception represents a Parameter exception.
    /// </summary>
    public class NoResponseKeyException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="NoResponseKeyException"/> class. 
        /// </summary>
        /// <param name="message">The ParameterException error message</param>
        /// <param name="context">The context execution</param>
        public NoResponseKeyException(string message, IEnumerable<KeyValuePair<string, object>> context)
            : base(message)
        {
            this.Context = context;
        }

        /// <summary>
        /// Gets or sets the context
        /// </summary>
        public IEnumerable<KeyValuePair<string, object>> Context { get; set; }
    }
}