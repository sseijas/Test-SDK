// -----------------------------------------------------------------------
// <copyright file="Log.cs" company="Prisma">
// Baufest (c) 2016
// </copyright>
// -----------------------------------------------------------------------

namespace Adapter
{
    using System;

    /// <summary>
    /// Provides Log to Console
    /// </summary>
    public class Log
    {
        /// <summary>
        /// Writes a error message with red color
        /// </summary>
        /// <param name="message">The message to write</param>
        public static void Error(string message)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        /// <summary>
        /// Writes a error message with white color
        /// </summary>
        /// <param name="message">The message to write</param>
        public static void Info(string message)
        {
            Console.ForegroundColor = ConsoleColor.Gray;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        /// <summary>
        /// Writes a error message with white color
        /// </summary>
        /// <param name="message">The message to write</param>
        public static void Title(string message)
        {
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine(message);
            Console.ResetColor();
        }
    }
}
