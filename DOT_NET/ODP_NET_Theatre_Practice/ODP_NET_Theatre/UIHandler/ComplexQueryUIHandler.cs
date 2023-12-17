using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.UIHandler
{
    public class ComplexQueryUIHandler
    {
        public void HandleMenu()
        {
            String answer;
            do
            {
                Console.WriteLine("\nOdaberite funkcionalnost:");
                Console.WriteLine("\n1  - X");
                Console.WriteLine("\n2  - X");
                Console.WriteLine("\n3  - X");

                Console.WriteLine("\nX  - Izlazak iz kompleksnih upita");

                answer = Console.ReadLine();

                switch (answer)
                {
                    case "1":
                        // TODO:
                        break;
                    case "2":
                        // TODO:
                        break;
                    case "3":
                        // TODO:
                        break;
                }

            } while (!answer.ToUpper().Equals("X"));
        }

    }
}
