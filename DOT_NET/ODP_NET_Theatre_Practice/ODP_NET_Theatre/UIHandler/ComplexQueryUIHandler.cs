using ODP_NET_Theatre.DTO.ComplexQuery1;
using ODP_NET_Theatre.Model;
using ODP_NET_Theatre.Service;
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

        private static readonly ComplexFuncionalityService complexQueryService = new ComplexFuncionalityService();

        public void HandleMenu()
        {
            String answer;
            do
            {
                Console.WriteLine("\n1  - Za svako pozoriste prikazati listu scene koje ima. Ukoliko pozoriste nema scenu ispisati: NEMA SCENE");
                Console.WriteLine("\n2  - X");
                Console.WriteLine("\n3  - X");

                Console.WriteLine("\nX  - Izlazak iz kompleksnih upita");

                answer = Console.ReadLine();

                switch (answer)
                {
                    case "1":
                        ShowSceneForTheatre();
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

        private void ShowSceneForTheatre() 
        {
            try
            {
                List<ScenesForTheatreDTO> dtos = complexQueryService.GetScenesForTheatres();
                if(dtos.Count != 0)
                {
                    foreach(ScenesForTheatreDTO dto in dtos)
                    {
                        Console.WriteLine(dto.Theatre);
                        Console.WriteLine("\t\t------------------------------- SCENE -------------------------------");

                        if(dto.Scenes.Count != 0)
                        {
                            Console.WriteLine("\t\t" + Scene.GetFormattedHeader());
                            foreach(Scene scene in dto.Scenes)
                            {
                                Console.WriteLine("\t\t" + scene);
                            }
                        }
                        else
                        {
                            Console.WriteLine("\t\tNEMA SCENE");

                        }
                        Console.WriteLine("\t\t---------------------------------------------------------------------");
                        Console.WriteLine();
                    }
                }
                else
                {
                    Console.WriteLine("\t\tNEMA POZORISTA.");
                }
            }catch(DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

    }
}
